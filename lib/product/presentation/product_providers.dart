import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/catalog_providers.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../domain/product.dart';

final productDetailsProvider = StreamProvider.autoDispose
    .family<Result<Product?, CatalogFailure>, String>((ref, productId) {
      // Dispose the query when the detail route no longer needs this ID.
      return ref.watch(productRepositoryProvider).watchProduct(productId);
    });
