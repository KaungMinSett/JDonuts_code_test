import 'package:drift/drift.dart';

import '../../app/data/catalog_database.dart';
import '../../app/data/catalog_store.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/member_profile.dart';
import '../../core/domain/result.dart';
import '../../product/data/product_row_mapping.dart';
import '../../product/domain/product.dart';
import '../domain/home_repository.dart';

final class DriftHomeRepository implements HomeRepository {
  const DriftHomeRepository(this._store);

  final CatalogStore _store;

  @override
  Future<Result<void, CatalogFailure>> refreshCatalog() => _store.refresh();

  @override
  Stream<Result<MemberProfile?, CatalogFailure>> watchMember() {
    return _store.watch((database) {
      // The demo uses one shared profile for tier and points.
      return database
          .select(database.members)
          .watchSingleOrNull()
          .map(
            (member) => member == null
                ? null
                : (
                    id: member.id,
                    name: member.name,
                    imageAsset: member.imageAsset,
                    tier: member.tier,
                    points: member.points,
                    nextTier: member.nextTier,
                    nextTierPoints: member.nextTierPoints,
                    notificationCount: member.notificationCount,
                  ),
          );
    });
  }

  @override
  Stream<Result<List<HomeBanner>, CatalogFailure>> watchBanners() {
    return _store.watch((database) {
      final banners = database.select(database.homeBanners)
        ..orderBy([(banner) => OrderingTerm.asc(banner.position)]);
      return banners.watch().map(
        (rows) => List<HomeBanner>.unmodifiable(
          rows.map(
            (row) => (
              id: row.id,
              title: row.title,
              badgeLabel: row.badgeLabel,
              imageAsset: row.imageAsset,
            ),
          ),
        ),
      );
    });
  }

  @override
  Stream<Result<List<HomeSection>, CatalogFailure>> watchSections() {
    return _store.watch((database) {
      final sections = database.homeSections;
      final memberships = database.homeSectionProducts;
      final products = database.products;
      // Left joins keep sections with no products visible for the empty state.
      final query =
          database.select(sections).join([
            leftOuterJoin(
              memberships,
              memberships.sectionId.equalsExp(sections.id),
            ),
            leftOuterJoin(
              products,
              products.id.equalsExp(memberships.productId),
            ),
          ])..orderBy([
            OrderingTerm.asc(sections.position),
            OrderingTerm.asc(memberships.position),
          ]);
      return query.watch().map((rows) => _groupSections(rows, database));
    });
  }

  @override
  Stream<Result<List<NearbyShop>, CatalogFailure>> watchShops() {
    return _store.watch((database) {
      final shops = database.select(database.nearbyShops)
        ..orderBy([(shop) => OrderingTerm.asc(shop.position)]);
      return shops.watch().map(
        (rows) => List<NearbyShop>.unmodifiable(
          rows.map(
            (row) => (
              id: row.id,
              name: row.name,
              location: row.location,
              imageAsset: row.imageAsset,
            ),
          ),
        ),
      );
    });
  }
}

List<HomeSection> _groupSections(
  List<TypedResult> rows,
  CatalogDatabase database,
) {
  // Group ordered memberships by section while keeping the domain data immutable.
  final productsBySection = <HomeSectionRow, List<Product>>{};
  for (final row in rows) {
    final sectionProducts = productsBySection.putIfAbsent(
      row.readTable(database.homeSections),
      () => [],
    );
    final product = row.readTableOrNull(database.products);
    if (product != null) sectionProducts.add(product.toProduct());
  }
  return List.unmodifiable(
    productsBySection.entries.map(
      (entry) => (
        id: entry.key.id,
        title: entry.key.title,
        products: List<Product>.unmodifiable(entry.value),
      ),
    ),
  );
}
