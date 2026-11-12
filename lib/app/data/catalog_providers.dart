import 'dart:async';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/data/drift_home_repository.dart';
import '../../home/domain/home_repository.dart';
import '../../product/data/drift_product_repository.dart';
import '../../product/domain/product_repository.dart';
import '../../rewards/data/drift_rewards_repository.dart';
import '../../rewards/domain/rewards_repository.dart';
import 'catalog_database.dart';
import 'catalog_store.dart';

final catalogStoreProvider = Provider<CatalogStore>((ref) {
  // The catalog repositories share one persistent SQLite connection in this scope.
  final database = CatalogDatabase(driftDatabase(name: 'jdonuts_catalog'));
  ref.onDispose(() => unawaited(database.close()));
  return CatalogStore(
    database,
    loadSeed: () => rootBundle.loadString('assets/data/catalog_seed.json'),
    loadRefresh: () =>
        rootBundle.loadString('assets/data/catalog_refresh.json'),
  );
});

// Bind the catalog repositories to their domain interfaces in the app wiring.
final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => DriftHomeRepository(ref.watch(catalogStoreProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => DriftProductRepository(ref.watch(catalogStoreProvider)),
);

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => DriftRewardsRepository(ref.watch(catalogStoreProvider)),
);
