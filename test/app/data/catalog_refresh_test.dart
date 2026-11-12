import 'dart:async';
import 'dart:io';

import 'package:donuts_code_test/app/data/catalog_database.dart';
import 'package:donuts_code_test/app/data/catalog_store.dart';
import 'package:donuts_code_test/core/domain/catalog_failure.dart';
import 'package:donuts_code_test/core/domain/member_profile.dart';
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
          final seasonal = sections.singleWhere(
            (section) => section.id == 'seasonal',
          );
          return seasonal.products
              .singleWhere((product) => product.id == 'p_coconut')
              .discountPercent;
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

  test('The bundled catalog seeds every Home section in order', () async {
    final member =
        (await home.watchMember().first
                as Success<MemberProfile?, CatalogFailure>)
            .value!;
    final banners =
        (await home.watchBanners().first
                as Success<List<HomeBanner>, CatalogFailure>)
            .value;
    final sections =
        (await home.watchSections().first
                as Success<List<HomeSection>, CatalogFailure>)
            .value;
    final shops =
        (await home.watchShops().first
                as Success<List<NearbyShop>, CatalogFailure>)
            .value;

    expect(member.tier, 'Silver');
    expect(member.nextTierPoints - member.points, 500);
    expect(banners.map((banner) => banner.id), [
      'seasonal_favorites',
      'share_a_box',
    ]);
    expect(banners.map((banner) => (banner.imageAsset, banner.badgeLabel)), [
      ('assets/images/donutshop_1.jpg', 'New shop'),
      ('assets/images/donutshop_2.jpg', '50% off'),
    ]);
    expect(sections.map((section) => section.id), [
      'seasonal',
      'popular',
      'order_again',
    ]);
    final seasonal = sections.first;
    final coconut = seasonal.products.singleWhere(
      (product) => product.id == 'p_coconut',
    );
    expect(coconut.imageAsset, 'assets/images/donut_1.jpg');
    expect(Uri.parse(coconut.imageUrl!).host, 'img.magnific.com');
    expect(
      seasonal.products.map((product) => (product.id, product.discountPercent)),
      [('p_strawberry', 30), ('p_coconut', 10)],
    );
    expect(shops.map((shop) => shop.id), [
      'junction_city',
      'myanmar_plaza',
      'hledan',
      'junction_square',
    ]);

    // Each linked product opens the same domain record in Product Detail.
    for (final section in sections) {
      for (final product in section.products) {
        final detail = await products.watchProduct(product.id).first;
        expect((detail as Success<Product?, CatalogFailure>).value, product);
      }
    }
  });
}
