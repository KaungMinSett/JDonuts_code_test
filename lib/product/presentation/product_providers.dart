import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/catalog_providers.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../data/drift_product_repository.dart';
import '../domain/product.dart';
import '../domain/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => DriftProductRepository(ref.watch(catalogStoreProvider)),
);

final productDetailsProvider = StreamProvider.autoDispose
    .family<Result<Product?, CatalogFailure>, String>((ref, productId) {
      // Dispose the query when the detail route no longer needs this ID.
      return ref.watch(productRepositoryProvider).watchProduct(productId);
    });
