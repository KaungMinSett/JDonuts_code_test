import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import 'product.dart';

abstract interface class ProductRepository {
  Stream<Result<Product?, CatalogFailure>> watchProduct(String id);
}
