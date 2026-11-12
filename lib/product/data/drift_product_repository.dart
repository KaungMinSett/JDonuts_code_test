import '../../app/data/catalog_store.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../domain/product.dart';
import '../domain/product_repository.dart';
import 'product_row_mapping.dart';

final class DriftProductRepository implements ProductRepository {
  const DriftProductRepository(this._store);

  final CatalogStore _store;

  @override
  Stream<Result<Product?, CatalogFailure>> watchProduct(String id) {
    return _store.watch((database) {
      // A missing ID has its own screen state and is a valid query result.
      final query = database.select(database.products)
        ..where((product) => product.id.equals(id));
      return query.watchSingleOrNull().map((row) => row?.toProduct());
    });
  }
}
