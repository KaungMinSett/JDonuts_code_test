import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/catalog_providers.dart';
import '../../auth/auth_providers.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/member_profile.dart';
import '../../core/domain/result.dart';
import '../data/drift_home_repository.dart';
import '../domain/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => DriftHomeRepository(ref.watch(catalogStoreProvider)),
);

final memberProfileProvider =
    StreamProvider.autoDispose<Result<MemberProfile?, CatalogFailure>>((ref) {
      final home = ref.watch(homeRepositoryProvider);
      final auth = ref.watch(authRepositoryProvider);
      return home.watchMember().asyncMap((result) async {
        if (result case Success(value: final MemberProfile member)) {
          // Combine the registered name with the shared local loyalty data.
          return switch (await auth.readSignedInName()) {
            Success(value: final String name) => Success(
              _withName(member, name),
            ),
            Success() => result,
            Failure() => const Failure(CatalogFailure.unavailable),
          };
        }
        return result;
      });
    });

MemberProfile _withName(MemberProfile member, String name) => (
  id: member.id,
  name: name,
  imageAsset: member.imageAsset,
  tier: member.tier,
  tierStartPoints: member.tierStartPoints,
  points: member.points,
  nextTier: member.nextTier,
  nextTierPoints: member.nextTierPoints,
  notificationCount: member.notificationCount,
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
