import 'package:drift/drift.dart';

import '../../app/data/catalog_database.dart';
import '../../app/data/catalog_store.dart';
import '../../core/domain/catalog_failure.dart';
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
