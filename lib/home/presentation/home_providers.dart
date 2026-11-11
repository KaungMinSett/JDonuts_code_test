import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/catalog_providers.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../data/drift_home_repository.dart';
import '../domain/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => DriftHomeRepository(ref.watch(catalogStoreProvider)),
);

final homeSectionsProvider =
    StreamProvider.autoDispose<Result<List<HomeSection>, CatalogFailure>>(
      (ref) => ref.watch(homeRepositoryProvider).watchSections(),
    );
