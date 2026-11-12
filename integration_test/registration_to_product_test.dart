import 'package:donuts_code_test/app/app.dart';
import 'package:donuts_code_test/app/data/catalog_database.dart';
import 'package:donuts_code_test/app/data/catalog_providers.dart';
import 'package:donuts_code_test/app/data/catalog_store.dart';
import 'package:donuts_code_test/app/network/reachability_providers.dart';
import 'package:donuts_code_test/auth/auth_providers.dart';
import 'package:donuts_code_test/auth/data/fake_auth_repository.dart';
import 'package:donuts_code_test/product/presentation/product_detail_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('A new member can open a seeded product from Home', (
    tester,
  ) async {
    await _launchApp(tester);

    // Follow the registration screens with a new account and the demo OTP.
    await _tapWhenReady(tester, find.text('LET’S GET STARTED'));
    await _waitFor(tester, find.text('Enter your phone number'));
    await tester.enterText(find.byType(TextField), '09254135592');
    await _tapWhenReady(tester, find.widgetWithText(FilledButton, 'CONTINUE'));
    await _waitFor(tester, find.text('Verify your number'));
    await tester.enterText(find.byType(TextField), '123456');

    await _waitFor(tester, find.text('What’s your name?'));
    await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'May');
    await _tapWhenReady(tester, find.widgetWithText(FilledButton, 'CONTINUE'));
    await _selectAdultBirthday(tester);
    await _tapWhenReady(tester, find.widgetWithText(FilledButton, 'CONTINUE'));

    // Verify the registered name and open a product with a bundled photo.
    await _tapWhenReady(tester, find.text('LET’S EXPLORE'));
    await _waitFor(tester, find.text('May'));
    final product = find.text('Strawberry Sprinkle');
    await _tapWhenReady(tester, product);
    final detail = find.byType(ProductDetailScreen);
    await _waitFor(tester, find.descendant(of: detail, matching: product));
    expect(
      find.descendant(of: detail, matching: find.text('JD022124')),
      findsOneWidget,
    );
  });
}

Future<void> _launchApp(WidgetTester tester) async {
  // Use the real repositories without touching an existing device account or database.
  FlutterSecureStorage.setMockInitialValues({});
  final database = CatalogDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const FakeAuthRepository(delay: Duration.zero),
        ),
        catalogStoreProvider.overrideWithValue(
          CatalogStore(
            database,
            loadSeed: () =>
                rootBundle.loadString('assets/data/catalog_seed.json'),
            loadRefresh: () =>
                rootBundle.loadString('assets/data/catalog_refresh.json'),
          ),
        ),
        isOnlineProvider.overrideWith((ref) => Stream.value(false)),
      ],
      child: const JDonutsApp(),
    ),
  );
}

Future<void> _selectAdultBirthday(WidgetTester tester) async {
  await _waitFor(tester, find.text('What’s your date of birth?'));
  await _tapWhenReady(tester, find.widgetWithText(InkWell, 'Month'));
  await tester.pumpAndSettle();

  // Move the real year wheel to an adult birthday without a long series of flings.
  final yearWheel = find.ancestor(
    of: find.text(DateTime.now().year.toString()),
    matching: find.byType(CupertinoPicker),
  );
  final controller = tester
      .widget<CupertinoPicker>(yearWheel)
      .scrollController!;
  controller.jumpToItem(controller.selectedItem - 20);
  await tester.pumpAndSettle();
  await _tapWhenReady(tester, find.text('Done'));
  await tester.pumpAndSettle();
}

Future<void> _tapWhenReady(WidgetTester tester, Finder finder) async {
  await _waitFor(tester, finder);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  // Give routing and the SQLite queries time to finish on a real device.
  for (var attempt = 0; attempt < 100; attempt++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsOneWidget);
}
