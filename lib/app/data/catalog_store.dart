import 'dart:developer' as developer;

import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import 'catalog_database.dart';
import 'catalog_seed.dart';

final class CatalogStore {
  CatalogStore(this._database, {required this._loadSeed});

  static const _seedId = 'initial_catalog';
  final CatalogDatabase _database;
  final Future<String> Function() _loadSeed;

  Stream<Result<T, CatalogFailure>> watch<T>(
    Stream<T> Function(CatalogDatabase database) query,
  ) async* {
    try {
      // Subscribers only see catalog rows after the initial import commits.
      await _ensureSeeded();
      await for (final value in query(_database)) {
        yield Success(value);
      }
    } catch (error, stackTrace) {
      developer.log(
        'Could not read the local catalog.',
        name: 'CatalogStore',
        error: error,
        stackTrace: stackTrace,
      );
      yield Failure(CatalogFailure.unavailable);
    }
  }

  Future<void> _ensureSeeded() async {
    if (await _hasSeed()) return;
    final seed = parseCatalogSeed(await _loadSeed());

    // Commit the rows and completion marker together. A failed import can retry.
    await _database.transaction(() async {
      // Another reader may have seeded while we parsed the fixture.
      if (await _hasSeed()) return;
      await _database.batch((batch) {
        batch.insertAll(_database.products, seed.products);
        batch.insertAll(_database.homeSections, seed.sections);
        batch.insertAll(_database.homeSectionProducts, seed.memberships);
        batch.insert(_database.catalogSeeds, const CatalogSeedRow(id: _seedId));
      });
    });
  }

  Future<bool> _hasSeed() async {
    final marker = _database.select(_database.catalogSeeds)
      ..where((seed) => seed.id.equals(_seedId));
    return await marker.getSingleOrNull() != null;
  }
}
