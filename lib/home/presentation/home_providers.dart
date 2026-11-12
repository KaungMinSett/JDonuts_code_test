import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/catalog_providers.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/member_profile.dart';
import '../../core/domain/result.dart';
import '../data/drift_home_repository.dart';
import '../domain/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => DriftHomeRepository(ref.watch(catalogStoreProvider)),
);

final memberProfileProvider =
    StreamProvider.autoDispose<Result<MemberProfile?, CatalogFailure>>(
      (ref) => ref.watch(homeRepositoryProvider).watchMember(),
    );

final homeBannersProvider =
    StreamProvider.autoDispose<Result<List<HomeBanner>, CatalogFailure>>(
      (ref) => ref.watch(homeRepositoryProvider).watchBanners(),
    );

final homeSectionsProvider =
    StreamProvider.autoDispose<Result<List<HomeSection>, CatalogFailure>>(
      (ref) => ref.watch(homeRepositoryProvider).watchSections(),
    );

final homeNearbyShopsProvider =
    StreamProvider.autoDispose<Result<List<NearbyShop>, CatalogFailure>>(
      (ref) => ref.watch(homeRepositoryProvider).watchShops(),
    );
