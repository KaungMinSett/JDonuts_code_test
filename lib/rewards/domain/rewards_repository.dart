import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';

typedef RewardChallenge = ({
  String id,
  String title,
  int completed,
  int target,
  int rewardPoints,
  String? imageAsset,
});

abstract interface class RewardsRepository {
  Stream<Result<List<RewardChallenge>, CatalogFailure>> watchChallenges();
}
