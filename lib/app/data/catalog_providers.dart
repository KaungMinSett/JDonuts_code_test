import 'dart:async';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'catalog_database.dart';
import 'catalog_store.dart';

final catalogStoreProvider = Provider<CatalogStore>((ref) {
  // Both features share one persistent SQLite connection in this provider scope.
  final database = CatalogDatabase(driftDatabase(name: 'jdonuts_catalog'));
  ref.onDispose(() => unawaited(database.close()));
  return CatalogStore(
    database,
    loadSeed: () => rootBundle.loadString('assets/data/catalog_seed.json'),
    loadRefresh: () =>
        rootBundle.loadString('assets/data/catalog_refresh.json'),
  );
});
