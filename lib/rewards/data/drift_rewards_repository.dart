import 'package:drift/drift.dart';

import '../../app/data/catalog_store.dart';
import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import '../domain/rewards_repository.dart';

final class DriftRewardsRepository implements RewardsRepository {
  const DriftRewardsRepository(this._store);

  final CatalogStore _store;

  @override
  Stream<Result<List<RewardChallenge>, CatalogFailure>> watchChallenges() {
    return _store.watch((database) {
      // Keep the challenge order from the bundled fixture.
      final query = database.select(database.rewardChallenges)
        ..orderBy([(row) => OrderingTerm.asc(row.position)]);
      return query.watch().map(
        (rows) => List<RewardChallenge>.unmodifiable(
          rows.map(
            (row) => (
              id: row.id,
              title: row.title,
              completed: row.completed,
              target: row.target,
              rewardPoints: row.rewardPoints,
              imageAsset: row.imageAsset,
            ),
          ),
        ),
      );
    });
  }
}
