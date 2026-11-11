// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMmkMeta = const VerificationMeta(
    'priceMmk',
  );
  @override
  late final GeneratedColumn<int> priceMmk = GeneratedColumn<int>(
    'price_mmk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew = GeneratedColumn<bool>(
    'is_new',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_new" IN (0, 1))',
    ),
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
    'discount_percent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    description,
    priceMmk,
    isNew,
    discountPercent,
    imageAsset,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('price_mmk')) {
      context.handle(
        _priceMmkMeta,
        priceMmk.isAcceptableOrUnknown(data['price_mmk']!, _priceMmkMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMmkMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
        _isNewMeta,
        isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta),
      );
    } else if (isInserting) {
      context.missing(_isNewMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      priceMmk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_mmk'],
      )!,
      isNew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_new'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_percent'],
      ),
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final String id;
  final String code;
  final String name;
  final String description;
  final int priceMmk;
  final bool isNew;
  final int? discountPercent;
  final String imageAsset;
  const ProductRow({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.priceMmk,
    required this.isNew,
    this.discountPercent,
    required this.imageAsset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['price_mmk'] = Variable<int>(priceMmk);
    map['is_new'] = Variable<bool>(isNew);
    if (!nullToAbsent || discountPercent != null) {
      map['discount_percent'] = Variable<int>(discountPercent);
    }
    map['image_asset'] = Variable<String>(imageAsset);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      description: Value(description),
      priceMmk: Value(priceMmk),
      isNew: Value(isNew),
      discountPercent: discountPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercent),
      imageAsset: Value(imageAsset),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      priceMmk: serializer.fromJson<int>(json['priceMmk']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      discountPercent: serializer.fromJson<int?>(json['discountPercent']),
      imageAsset: serializer.fromJson<String>(json['imageAsset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'priceMmk': serializer.toJson<int>(priceMmk),
      'isNew': serializer.toJson<bool>(isNew),
      'discountPercent': serializer.toJson<int?>(discountPercent),
      'imageAsset': serializer.toJson<String>(imageAsset),
    };
  }

  ProductRow copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    int? priceMmk,
    bool? isNew,
    Value<int?> discountPercent = const Value.absent(),
    String? imageAsset,
  }) => ProductRow(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    description: description ?? this.description,
    priceMmk: priceMmk ?? this.priceMmk,
    isNew: isNew ?? this.isNew,
    discountPercent: discountPercent.present
        ? discountPercent.value
        : this.discountPercent,
    imageAsset: imageAsset ?? this.imageAsset,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      priceMmk: data.priceMmk.present ? data.priceMmk.value : this.priceMmk,
      isNew: data.isNew.present ? data.isNew.value : this.isNew,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      imageAsset: data.imageAsset.present
          ? data.imageAsset.value
          : this.imageAsset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priceMmk: $priceMmk, ')
          ..write('isNew: $isNew, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('imageAsset: $imageAsset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    description,
    priceMmk,
    isNew,
    discountPercent,
    imageAsset,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.priceMmk == this.priceMmk &&
          other.isNew == this.isNew &&
          other.discountPercent == this.discountPercent &&
          other.imageAsset == this.imageAsset);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> description;
  final Value<int> priceMmk;
  final Value<bool> isNew;
  final Value<int?> discountPercent;
  final Value<String> imageAsset;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.priceMmk = const Value.absent(),
    this.isNew = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String code,
    required String name,
    required String description,
    required int priceMmk,
    required bool isNew,
    this.discountPercent = const Value.absent(),
    required String imageAsset,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       description = Value(description),
       priceMmk = Value(priceMmk),
       isNew = Value(isNew),
       imageAsset = Value(imageAsset);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? priceMmk,
    Expression<bool>? isNew,
    Expression<int>? discountPercent,
    Expression<String>? imageAsset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (priceMmk != null) 'price_mmk': priceMmk,
      if (isNew != null) 'is_new': isNew,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? description,
    Value<int>? priceMmk,
    Value<bool>? isNew,
    Value<int?>? discountPercent,
    Value<String>? imageAsset,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      priceMmk: priceMmk ?? this.priceMmk,
      isNew: isNew ?? this.isNew,
      discountPercent: discountPercent ?? this.discountPercent,
      imageAsset: imageAsset ?? this.imageAsset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priceMmk.present) {
      map['price_mmk'] = Variable<int>(priceMmk.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priceMmk: $priceMmk, ')
          ..write('isNew: $isNew, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HomeSectionsTable extends HomeSections
    with TableInfo<$HomeSectionsTable, HomeSectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<HomeSectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HomeSectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeSectionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $HomeSectionsTable createAlias(String alias) {
    return $HomeSectionsTable(attachedDatabase, alias);
  }
}

class HomeSectionRow extends DataClass implements Insertable<HomeSectionRow> {
  final String id;
  final String title;
  final int position;
  const HomeSectionRow({
    required this.id,
    required this.title,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['position'] = Variable<int>(position);
    return map;
  }

  HomeSectionsCompanion toCompanion(bool nullToAbsent) {
    return HomeSectionsCompanion(
      id: Value(id),
      title: Value(title),
      position: Value(position),
    );
  }

  factory HomeSectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeSectionRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'position': serializer.toJson<int>(position),
    };
  }

  HomeSectionRow copyWith({String? id, String? title, int? position}) =>
      HomeSectionRow(
        id: id ?? this.id,
        title: title ?? this.title,
        position: position ?? this.position,
      );
  HomeSectionRow copyWithCompanion(HomeSectionsCompanion data) {
    return HomeSectionRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeSectionRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeSectionRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.position == this.position);
}

class HomeSectionsCompanion extends UpdateCompanion<HomeSectionRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> position;
  final Value<int> rowid;
  const HomeSectionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomeSectionsCompanion.insert({
    required String id,
    required String title,
    required int position,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       position = Value(position);
  static Insertable<HomeSectionRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomeSectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return HomeSectionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeSectionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HomeSectionProductsTable extends HomeSectionProducts
    with TableInfo<$HomeSectionProductsTable, HomeSectionProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeSectionProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES home_sections (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sectionId, productId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_section_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<HomeSectionProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sectionId, productId};
  @override
  HomeSectionProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeSectionProduct(
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $HomeSectionProductsTable createAlias(String alias) {
    return $HomeSectionProductsTable(attachedDatabase, alias);
  }
}

class HomeSectionProduct extends DataClass
    implements Insertable<HomeSectionProduct> {
  final String sectionId;
  final String productId;
  final int position;
  const HomeSectionProduct({
    required this.sectionId,
    required this.productId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['section_id'] = Variable<String>(sectionId);
    map['product_id'] = Variable<String>(productId);
    map['position'] = Variable<int>(position);
    return map;
  }

  HomeSectionProductsCompanion toCompanion(bool nullToAbsent) {
    return HomeSectionProductsCompanion(
      sectionId: Value(sectionId),
      productId: Value(productId),
      position: Value(position),
    );
  }

  factory HomeSectionProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeSectionProduct(
      sectionId: serializer.fromJson<String>(json['sectionId']),
      productId: serializer.fromJson<String>(json['productId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sectionId': serializer.toJson<String>(sectionId),
      'productId': serializer.toJson<String>(productId),
      'position': serializer.toJson<int>(position),
    };
  }

  HomeSectionProduct copyWith({
    String? sectionId,
    String? productId,
    int? position,
  }) => HomeSectionProduct(
    sectionId: sectionId ?? this.sectionId,
    productId: productId ?? this.productId,
    position: position ?? this.position,
  );
  HomeSectionProduct copyWithCompanion(HomeSectionProductsCompanion data) {
    return HomeSectionProduct(
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      productId: data.productId.present ? data.productId.value : this.productId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeSectionProduct(')
          ..write('sectionId: $sectionId, ')
          ..write('productId: $productId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sectionId, productId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeSectionProduct &&
          other.sectionId == this.sectionId &&
          other.productId == this.productId &&
          other.position == this.position);
}

class HomeSectionProductsCompanion extends UpdateCompanion<HomeSectionProduct> {
  final Value<String> sectionId;
  final Value<String> productId;
  final Value<int> position;
  final Value<int> rowid;
  const HomeSectionProductsCompanion({
    this.sectionId = const Value.absent(),
    this.productId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomeSectionProductsCompanion.insert({
    required String sectionId,
    required String productId,
    required int position,
    this.rowid = const Value.absent(),
  }) : sectionId = Value(sectionId),
       productId = Value(productId),
       position = Value(position);
  static Insertable<HomeSectionProduct> custom({
    Expression<String>? sectionId,
    Expression<String>? productId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sectionId != null) 'section_id': sectionId,
      if (productId != null) 'product_id': productId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomeSectionProductsCompanion copyWith({
    Value<String>? sectionId,
    Value<String>? productId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return HomeSectionProductsCompanion(
      sectionId: sectionId ?? this.sectionId,
      productId: productId ?? this.productId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeSectionProductsCompanion(')
          ..write('sectionId: $sectionId, ')
          ..write('productId: $productId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogSeedsTable extends CatalogSeeds
    with TableInfo<$CatalogSeedsTable, CatalogSeedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogSeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_seeds';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogSeedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogSeedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogSeedRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
    );
  }

  @override
  $CatalogSeedsTable createAlias(String alias) {
    return $CatalogSeedsTable(attachedDatabase, alias);
  }
}

class CatalogSeedRow extends DataClass implements Insertable<CatalogSeedRow> {
  final String id;
  const CatalogSeedRow({required this.id});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    return map;
  }

  CatalogSeedsCompanion toCompanion(bool nullToAbsent) {
    return CatalogSeedsCompanion(id: Value(id));
  }

  factory CatalogSeedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogSeedRow(id: serializer.fromJson<String>(json['id']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<String>(id)};
  }

  CatalogSeedRow copyWith({String? id}) => CatalogSeedRow(id: id ?? this.id);
  CatalogSeedRow copyWithCompanion(CatalogSeedsCompanion data) {
    return CatalogSeedRow(id: data.id.present ? data.id.value : this.id);
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSeedRow(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogSeedRow && other.id == this.id);
}

class CatalogSeedsCompanion extends UpdateCompanion<CatalogSeedRow> {
  final Value<String> id;
  final Value<int> rowid;
  const CatalogSeedsCompanion({
    this.id = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogSeedsCompanion.insert({
    required String id,
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<CatalogSeedRow> custom({
    Expression<String>? id,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogSeedsCompanion copyWith({Value<String>? id, Value<int>? rowid}) {
    return CatalogSeedsCompanion(id: id ?? this.id, rowid: rowid ?? this.rowid);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSeedsCompanion(')
          ..write('id: $id, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CatalogDatabase extends GeneratedDatabase {
  _$CatalogDatabase(QueryExecutor e) : super(e);
  $CatalogDatabaseManager get managers => $CatalogDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $HomeSectionsTable homeSections = $HomeSectionsTable(this);
  late final $HomeSectionProductsTable homeSectionProducts =
      $HomeSectionProductsTable(this);
  late final $CatalogSeedsTable catalogSeeds = $CatalogSeedsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    homeSections,
    homeSectionProducts,
    catalogSeeds,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String code,
      required String name,
      required String description,
      required int priceMmk,
      required bool isNew,
      Value<int?> discountPercent,
      required String imageAsset,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String> description,
      Value<int> priceMmk,
      Value<bool> isNew,
      Value<int?> discountPercent,
      Value<String> imageAsset,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$CatalogDatabase, $ProductsTable, ProductRow> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $HomeSectionProductsTable,
    List<HomeSectionProduct>
  >
  _homeSectionProductsRefsTable(_$CatalogDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.homeSectionProducts,
        aliasName: $_aliasNameGenerator(
          db.products.id,
          db.homeSectionProducts.productId,
        ),
      );

  $$HomeSectionProductsTableProcessedTableManager get homeSectionProductsRefs {
    final manager = $$HomeSectionProductsTableTableManager(
      $_db,
      $_db.homeSectionProducts,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _homeSectionProductsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$CatalogDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMmk => $composableBuilder(
    column: $table.priceMmk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> homeSectionProductsRefs(
    Expression<bool> Function($$HomeSectionProductsTableFilterComposer f) f,
  ) {
    final $$HomeSectionProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeSectionProducts,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeSectionProductsTableFilterComposer(
            $db: $db,
            $table: $db.homeSectionProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$CatalogDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMmk => $composableBuilder(
    column: $table.priceMmk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$CatalogDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceMmk =>
      $composableBuilder(column: $table.priceMmk, builder: (column) => column);

  GeneratedColumn<bool> get isNew =>
      $composableBuilder(column: $table.isNew, builder: (column) => column);

  GeneratedColumn<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  Expression<T> homeSectionProductsRefs<T extends Object>(
    Expression<T> Function($$HomeSectionProductsTableAnnotationComposer a) f,
  ) {
    final $$HomeSectionProductsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.homeSectionProducts,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HomeSectionProductsTableAnnotationComposer(
                $db: $db,
                $table: $db.homeSectionProducts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$CatalogDatabase,
          $ProductsTable,
          ProductRow,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (ProductRow, $$ProductsTableReferences),
          ProductRow,
          PrefetchHooks Function({bool homeSectionProductsRefs})
        > {
  $$ProductsTableTableManager(_$CatalogDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> priceMmk = const Value.absent(),
                Value<bool> isNew = const Value.absent(),
                Value<int?> discountPercent = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                code: code,
                name: name,
                description: description,
                priceMmk: priceMmk,
                isNew: isNew,
                discountPercent: discountPercent,
                imageAsset: imageAsset,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required String description,
                required int priceMmk,
                required bool isNew,
                Value<int?> discountPercent = const Value.absent(),
                required String imageAsset,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                code: code,
                name: name,
                description: description,
                priceMmk: priceMmk,
                isNew: isNew,
                discountPercent: discountPercent,
                imageAsset: imageAsset,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({homeSectionProductsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (homeSectionProductsRefs) db.homeSectionProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (homeSectionProductsRefs)
                    await $_getPrefetchedData<
                      ProductRow,
                      $ProductsTable,
                      HomeSectionProduct
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._homeSectionProductsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).homeSectionProductsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogDatabase,
      $ProductsTable,
      ProductRow,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductRow, $$ProductsTableReferences),
      ProductRow,
      PrefetchHooks Function({bool homeSectionProductsRefs})
    >;
typedef $$HomeSectionsTableCreateCompanionBuilder =
    HomeSectionsCompanion Function({
      required String id,
      required String title,
      required int position,
      Value<int> rowid,
    });
typedef $$HomeSectionsTableUpdateCompanionBuilder =
    HomeSectionsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> position,
      Value<int> rowid,
    });

final class $$HomeSectionsTableReferences
    extends
        BaseReferences<_$CatalogDatabase, $HomeSectionsTable, HomeSectionRow> {
  $$HomeSectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $HomeSectionProductsTable,
    List<HomeSectionProduct>
  >
  _homeSectionProductsRefsTable(_$CatalogDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.homeSectionProducts,
        aliasName: $_aliasNameGenerator(
          db.homeSections.id,
          db.homeSectionProducts.sectionId,
        ),
      );

  $$HomeSectionProductsTableProcessedTableManager get homeSectionProductsRefs {
    final manager = $$HomeSectionProductsTableTableManager(
      $_db,
      $_db.homeSectionProducts,
    ).filter((f) => f.sectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _homeSectionProductsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HomeSectionsTableFilterComposer
    extends Composer<_$CatalogDatabase, $HomeSectionsTable> {
  $$HomeSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> homeSectionProductsRefs(
    Expression<bool> Function($$HomeSectionProductsTableFilterComposer f) f,
  ) {
    final $$HomeSectionProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeSectionProducts,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeSectionProductsTableFilterComposer(
            $db: $db,
            $table: $db.homeSectionProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HomeSectionsTableOrderingComposer
    extends Composer<_$CatalogDatabase, $HomeSectionsTable> {
  $$HomeSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HomeSectionsTableAnnotationComposer
    extends Composer<_$CatalogDatabase, $HomeSectionsTable> {
  $$HomeSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  Expression<T> homeSectionProductsRefs<T extends Object>(
    Expression<T> Function($$HomeSectionProductsTableAnnotationComposer a) f,
  ) {
    final $$HomeSectionProductsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.homeSectionProducts,
          getReferencedColumn: (t) => t.sectionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HomeSectionProductsTableAnnotationComposer(
                $db: $db,
                $table: $db.homeSectionProducts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HomeSectionsTableTableManager
    extends
        RootTableManager<
          _$CatalogDatabase,
          $HomeSectionsTable,
          HomeSectionRow,
          $$HomeSectionsTableFilterComposer,
          $$HomeSectionsTableOrderingComposer,
          $$HomeSectionsTableAnnotationComposer,
          $$HomeSectionsTableCreateCompanionBuilder,
          $$HomeSectionsTableUpdateCompanionBuilder,
          (HomeSectionRow, $$HomeSectionsTableReferences),
          HomeSectionRow,
          PrefetchHooks Function({bool homeSectionProductsRefs})
        > {
  $$HomeSectionsTableTableManager(
    _$CatalogDatabase db,
    $HomeSectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomeSectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeSectionsCompanion(
                id: id,
                title: title,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => HomeSectionsCompanion.insert(
                id: id,
                title: title,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HomeSectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({homeSectionProductsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (homeSectionProductsRefs) db.homeSectionProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (homeSectionProductsRefs)
                    await $_getPrefetchedData<
                      HomeSectionRow,
                      $HomeSectionsTable,
                      HomeSectionProduct
                    >(
                      currentTable: table,
                      referencedTable: $$HomeSectionsTableReferences
                          ._homeSectionProductsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HomeSectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).homeSectionProductsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sectionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HomeSectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogDatabase,
      $HomeSectionsTable,
      HomeSectionRow,
      $$HomeSectionsTableFilterComposer,
      $$HomeSectionsTableOrderingComposer,
      $$HomeSectionsTableAnnotationComposer,
      $$HomeSectionsTableCreateCompanionBuilder,
      $$HomeSectionsTableUpdateCompanionBuilder,
      (HomeSectionRow, $$HomeSectionsTableReferences),
      HomeSectionRow,
      PrefetchHooks Function({bool homeSectionProductsRefs})
    >;
typedef $$HomeSectionProductsTableCreateCompanionBuilder =
    HomeSectionProductsCompanion Function({
      required String sectionId,
      required String productId,
      required int position,
      Value<int> rowid,
    });
typedef $$HomeSectionProductsTableUpdateCompanionBuilder =
    HomeSectionProductsCompanion Function({
      Value<String> sectionId,
      Value<String> productId,
      Value<int> position,
      Value<int> rowid,
    });

final class $$HomeSectionProductsTableReferences
    extends
        BaseReferences<
          _$CatalogDatabase,
          $HomeSectionProductsTable,
          HomeSectionProduct
        > {
  $$HomeSectionProductsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HomeSectionsTable _sectionIdTable(_$CatalogDatabase db) =>
      db.homeSections.createAlias(
        $_aliasNameGenerator(
          db.homeSectionProducts.sectionId,
          db.homeSections.id,
        ),
      );

  $$HomeSectionsTableProcessedTableManager get sectionId {
    final $_column = $_itemColumn<String>('section_id')!;

    final manager = $$HomeSectionsTableTableManager(
      $_db,
      $_db.homeSections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$CatalogDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.homeSectionProducts.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HomeSectionProductsTableFilterComposer
    extends Composer<_$CatalogDatabase, $HomeSectionProductsTable> {
  $$HomeSectionProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$HomeSectionsTableFilterComposer get sectionId {
    final $$HomeSectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.homeSections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeSectionsTableFilterComposer(
            $db: $db,
            $table: $db.homeSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeSectionProductsTableOrderingComposer
    extends Composer<_$CatalogDatabase, $HomeSectionProductsTable> {
  $$HomeSectionProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$HomeSectionsTableOrderingComposer get sectionId {
    final $$HomeSectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.homeSections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeSectionsTableOrderingComposer(
            $db: $db,
            $table: $db.homeSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeSectionProductsTableAnnotationComposer
    extends Composer<_$CatalogDatabase, $HomeSectionProductsTable> {
  $$HomeSectionProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$HomeSectionsTableAnnotationComposer get sectionId {
    final $$HomeSectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.homeSections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeSectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeSectionProductsTableTableManager
    extends
        RootTableManager<
          _$CatalogDatabase,
          $HomeSectionProductsTable,
          HomeSectionProduct,
          $$HomeSectionProductsTableFilterComposer,
          $$HomeSectionProductsTableOrderingComposer,
          $$HomeSectionProductsTableAnnotationComposer,
          $$HomeSectionProductsTableCreateCompanionBuilder,
          $$HomeSectionProductsTableUpdateCompanionBuilder,
          (HomeSectionProduct, $$HomeSectionProductsTableReferences),
          HomeSectionProduct,
          PrefetchHooks Function({bool sectionId, bool productId})
        > {
  $$HomeSectionProductsTableTableManager(
    _$CatalogDatabase db,
    $HomeSectionProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeSectionProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeSectionProductsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HomeSectionProductsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sectionId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeSectionProductsCompanion(
                sectionId: sectionId,
                productId: productId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sectionId,
                required String productId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => HomeSectionProductsCompanion.insert(
                sectionId: sectionId,
                productId: productId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HomeSectionProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sectionId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sectionId,
                                referencedTable:
                                    $$HomeSectionProductsTableReferences
                                        ._sectionIdTable(db),
                                referencedColumn:
                                    $$HomeSectionProductsTableReferences
                                        ._sectionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$HomeSectionProductsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$HomeSectionProductsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HomeSectionProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogDatabase,
      $HomeSectionProductsTable,
      HomeSectionProduct,
      $$HomeSectionProductsTableFilterComposer,
      $$HomeSectionProductsTableOrderingComposer,
      $$HomeSectionProductsTableAnnotationComposer,
      $$HomeSectionProductsTableCreateCompanionBuilder,
      $$HomeSectionProductsTableUpdateCompanionBuilder,
      (HomeSectionProduct, $$HomeSectionProductsTableReferences),
      HomeSectionProduct,
      PrefetchHooks Function({bool sectionId, bool productId})
    >;
typedef $$CatalogSeedsTableCreateCompanionBuilder =
    CatalogSeedsCompanion Function({required String id, Value<int> rowid});
typedef $$CatalogSeedsTableUpdateCompanionBuilder =
    CatalogSeedsCompanion Function({Value<String> id, Value<int> rowid});

class $$CatalogSeedsTableFilterComposer
    extends Composer<_$CatalogDatabase, $CatalogSeedsTable> {
  $$CatalogSeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogSeedsTableOrderingComposer
    extends Composer<_$CatalogDatabase, $CatalogSeedsTable> {
  $$CatalogSeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogSeedsTableAnnotationComposer
    extends Composer<_$CatalogDatabase, $CatalogSeedsTable> {
  $$CatalogSeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);
}

class $$CatalogSeedsTableTableManager
    extends
        RootTableManager<
          _$CatalogDatabase,
          $CatalogSeedsTable,
          CatalogSeedRow,
          $$CatalogSeedsTableFilterComposer,
          $$CatalogSeedsTableOrderingComposer,
          $$CatalogSeedsTableAnnotationComposer,
          $$CatalogSeedsTableCreateCompanionBuilder,
          $$CatalogSeedsTableUpdateCompanionBuilder,
          (
            CatalogSeedRow,
            BaseReferences<
              _$CatalogDatabase,
              $CatalogSeedsTable,
              CatalogSeedRow
            >,
          ),
          CatalogSeedRow,
          PrefetchHooks Function()
        > {
  $$CatalogSeedsTableTableManager(
    _$CatalogDatabase db,
    $CatalogSeedsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogSeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogSeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogSeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogSeedsCompanion(id: id, rowid: rowid),
          createCompanionCallback:
              ({required String id, Value<int> rowid = const Value.absent()}) =>
                  CatalogSeedsCompanion.insert(id: id, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogSeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogDatabase,
      $CatalogSeedsTable,
      CatalogSeedRow,
      $$CatalogSeedsTableFilterComposer,
      $$CatalogSeedsTableOrderingComposer,
      $$CatalogSeedsTableAnnotationComposer,
      $$CatalogSeedsTableCreateCompanionBuilder,
      $$CatalogSeedsTableUpdateCompanionBuilder,
      (
        CatalogSeedRow,
        BaseReferences<_$CatalogDatabase, $CatalogSeedsTable, CatalogSeedRow>,
      ),
      CatalogSeedRow,
      PrefetchHooks Function()
    >;

class $CatalogDatabaseManager {
  final _$CatalogDatabase _db;
  $CatalogDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$HomeSectionsTableTableManager get homeSections =>
      $$HomeSectionsTableTableManager(_db, _db.homeSections);
  $$HomeSectionProductsTableTableManager get homeSectionProducts =>
      $$HomeSectionProductsTableTableManager(_db, _db.homeSectionProducts);
  $$CatalogSeedsTableTableManager get catalogSeeds =>
      $$CatalogSeedsTableTableManager(_db, _db.catalogSeeds);
}
