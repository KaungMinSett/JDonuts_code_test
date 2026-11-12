import 'package:drift/drift.dart';

part 'catalog_database.g.dart';

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get priceMmk => integer()();
  BoolColumn get isNew => boolean()();
  IntColumn get discountPercent => integer().nullable()();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('HomeSectionRow')
class HomeSections extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class HomeSectionProducts extends Table {
  TextColumn get sectionId => text().references(HomeSections, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {sectionId, productId};
}

@DataClassName('CatalogSeedRow')
class CatalogSeeds extends Table {
  TextColumn get id => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Products, HomeSections, HomeSectionProducts, CatalogSeeds],
)
class CatalogDatabase extends _$CatalogDatabase {
  CatalogDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    beforeOpen: (_) async {
      // Enforce catalog references on every connection, including after relaunch.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
