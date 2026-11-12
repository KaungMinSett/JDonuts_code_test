import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/catalog_providers.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../data/drift_rewards_repository.dart';
import '../domain/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => DriftRewardsRepository(ref.watch(catalogStoreProvider)),
);

final rewardChallengesProvider =
    StreamProvider.autoDispose<Result<List<RewardChallenge>, CatalogFailure>>(
      (ref) => ref.watch(rewardsRepositoryProvider).watchChallenges(),
    );
