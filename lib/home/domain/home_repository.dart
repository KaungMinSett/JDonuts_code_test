import '../../core/domain/catalog_failure.dart';
import '../../core/domain/member_profile.dart';
import '../../core/domain/result.dart';
import '../../product/domain/product.dart';

typedef HomeSection = ({String id, String title});
typedef HomeBanner = ({
  String id,
  String title,
  String badgeLabel,
  String imageAsset,
});
typedef NearbyShop = ({
  String id,
  String name,
  String location,
  String imageAsset,
});

abstract interface class HomeRepository {
  Stream<Result<MemberProfile?, CatalogFailure>> watchMember();

  Stream<Result<List<HomeBanner>, CatalogFailure>> watchBanners();

  Stream<Result<List<HomeSection>, CatalogFailure>> watchSections();

  Stream<Result<List<Product>, CatalogFailure>> watchSectionProducts(
    String sectionId,
  );

  Stream<Result<List<NearbyShop>, CatalogFailure>> watchShops();

  Future<Result<void, CatalogFailure>> refreshCatalog();
}
