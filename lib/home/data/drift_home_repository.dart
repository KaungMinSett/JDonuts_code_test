import 'package:drift/drift.dart';

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
                    tierStartPoints: member.tierStartPoints,
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
      // Keep titles and ordering available independently of product queries.
      final sections = database.select(database.homeSections)
        ..orderBy([(section) => OrderingTerm.asc(section.position)]);
      return sections.watch().map(
        (rows) => List<HomeSection>.unmodifiable(
          rows.map((row) => (id: row.id, title: row.title)),
        ),
      );
    });
  }

  @override
  Stream<Result<List<Product>, CatalogFailure>> watchSectionProducts(
    String sectionId,
  ) {
    return _store.watch((database) {
      final memberships = database.homeSectionProducts;
      final products = database.products;
      // Read only this section's products in membership order.
      final query =
          database.select(memberships).join([
              innerJoin(products, products.id.equalsExp(memberships.productId)),
            ])
            ..where(memberships.sectionId.equals(sectionId))
            ..orderBy([OrderingTerm.asc(memberships.position)]);
      return query.watch().map(
        (rows) => List<Product>.unmodifiable(
          rows.map((row) => row.readTable(products).toProduct()),
        ),
      );
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
