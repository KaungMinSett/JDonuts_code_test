import 'package:donuts_code_test/app/app.dart';
import 'package:donuts_code_test/app/app_router.dart';
import 'package:donuts_code_test/auth/auth_providers.dart';
import 'package:donuts_code_test/auth/data/fake_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('An unregistered login number carries over to sign-up', (
    tester,
  ) async {
    await _pumpAuthApp(tester);
    const phone = '09254135592';
    final loginLink = find.text('Log In');
    await tester.ensureVisible(loginLink);
    await tester.tap(loginLink);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), phone);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUE'));
    await tester.pumpAndSettle();

    expect(find.text('This number isn’t registered.'), findsOneWidget);
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      phone,
    );
  });

  testWidgets('Confirming an underage birthday keeps Continue disabled', (
    tester,
  ) async {
    await _pumpAuthApp(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(JDonutsApp)),
    );
    // Start at the birthday step with a verified registration draft.
    container
        .read(routerProvider)
        .go(
          '/phone/date-of-birth',
          extra: {
            'normalizedPhone': '+959254135592',
            'firstName': 'May',
            'lastName': null,
          },
        );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(InkWell, 'Month'));
    await tester.pumpAndSettle();
    // The picker starts on today, which is always below the age minimum.
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(
      find.text('You must be at least 13 years old to register.'),
      findsOneWidget,
    );
    final continueButton = find.widgetWithText(FilledButton, 'CONTINUE');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);
  });
}

Future<void> _pumpAuthApp(WidgetTester tester) async {
  // Use the app's fake repository with isolated storage and no simulated delay.
  FlutterSecureStorage.setMockInitialValues({});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const FakeAuthRepository(delay: Duration.zero),
        ),
      ],
      child: const JDonutsApp(),
    ),
  );
  await tester.pumpAndSettle();
}
