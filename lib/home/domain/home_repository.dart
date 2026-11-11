import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../../product/domain/product.dart';

typedef HomeSection = ({String id, String title, List<Product> products});

abstract interface class HomeRepository {
  Stream<Result<List<HomeSection>, CatalogFailure>> watchSections();
}
