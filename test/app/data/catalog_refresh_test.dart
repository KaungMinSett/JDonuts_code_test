import 'dart:async';
import 'dart:io';

import 'package:donuts_code_test/app/data/catalog_database.dart';
import 'package:donuts_code_test/app/data/catalog_store.dart';
import 'package:donuts_code_test/core/domain/catalog_failure.dart';
import 'package:donuts_code_test/core/domain/result.dart';
import 'package:donuts_code_test/home/data/drift_home_repository.dart';
import 'package:donuts_code_test/home/domain/home_repository.dart';
import 'package:donuts_code_test/product/data/drift_product_repository.dart';
import 'package:donuts_code_test/product/domain/product.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CatalogDatabase database;
  late DriftHomeRepository home;
  late DriftProductRepository products;
  late String refreshResponse;
  late int refreshRequests;

  setUp(() async {
    // Use the bundled fixtures with a fresh SQLite database for each test.
    database = CatalogDatabase(NativeDatabase.memory());
    refreshResponse = await File(
      'assets/data/catalog_refresh.json',
    ).readAsString();
    refreshRequests = 0;
    final store = CatalogStore(
      database,
      loadSeed: File('assets/data/catalog_seed.json').readAsString,
      loadRefresh: () async {
        refreshRequests++;
        return refreshResponse;
      },
    );
    home = DriftHomeRepository(store);
    products = DriftProductRepository(store);
  });
  tearDown(() => database.close());

  Future<int?> readCoconutDiscount() async {
    final result = await products.watchProduct('p_coconut').first;
    return (result as Success<Product?, CatalogFailure>).value?.discountPercent;
  }

  test(
    'Overlapping refreshes share one request and update the open Home query',
    () async {
      final discounts = StreamIterator(
        home.watchSections().map((result) {
          final sections =
              (result as Success<List<HomeSection>, CatalogFailure>).value;
          return sections.single.products.single.discountPercent;
        }),
      );
      addTearDown(discounts.cancel);
      expect(await discounts.moveNext(), isTrue);
      expect(discounts.current, 10);

      final first = home.refreshCatalog();
      final second = home.refreshCatalog();
      expect(second, same(first));
      expect(await first, isA<Success<void, CatalogFailure>>());

      expect(refreshRequests, 1);
      expect(await discounts.moveNext(), isTrue);
      expect(discounts.current, 15);
      expect(await readCoconutDiscount(), 15);
    },
  );

  test('A rejected refresh preserves the previously saved discount', () async {
    expect(await home.refreshCatalog(), isA<Success<void, CatalogFailure>>());
    refreshResponse = '{"productId":"p_coconut","discountPercent":101}';

    expect(await home.refreshCatalog(), isA<Failure<void, CatalogFailure>>());
    expect(await readCoconutDiscount(), 15);
  });
}
