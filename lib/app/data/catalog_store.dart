import 'dart:developer' as developer;

import 'package:drift/drift.dart';

import '../../core/domain/catalog_failure.dart';
import '../../core/domain/result.dart';
import 'catalog_database.dart';
import 'catalog_fixtures.dart';

final class CatalogStore {
  CatalogStore(
    this._database, {
    required this._loadSeed,
    required this._loadRefresh,
  });

  static const _seedId = 'initial_catalog';
  final CatalogDatabase _database;
  final Future<String> Function() _loadSeed;
  final Future<String> Function() _loadRefresh;
  Future<Result<void, CatalogFailure>>? _refreshInProgress;

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

  Future<Result<void, CatalogFailure>> refresh() {
    // Reconnect and pull-to-refresh can share the same pending write.
    return _refreshInProgress ??= _applyRefresh().whenComplete(() {
      _refreshInProgress = null;
    });
  }

  Future<Result<void, CatalogFailure>> _applyRefresh() async {
    try {
      final update = parseCatalogDiscountUpdate(await _loadRefresh());
      await _ensureSeeded();

      // A single SQLite update changes only this product's public discount.
      final product = _database.update(_database.products)
        ..where((row) => row.id.equals(update.productId));
      final updatedRows = await product.write(
        ProductsCompanion(discountPercent: Value(update.discountPercent)),
      );
      if (updatedRows == 0) {
        throw FormatException('Unknown catalog product: ${update.productId}');
      }
      return const Success(null);
    } catch (error, stackTrace) {
      developer.log(
        'Could not refresh the local catalog.',
        name: 'CatalogStore',
        error: error,
        stackTrace: stackTrace,
      );
      return const Failure(CatalogFailure.unavailable);
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
