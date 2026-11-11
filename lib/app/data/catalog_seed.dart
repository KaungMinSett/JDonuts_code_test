import 'dart:convert';

import 'package:drift/drift.dart';

import 'catalog_database.dart';

const _maximumDiscountPercent = 100;

typedef CatalogSeed = ({
  List<ProductsCompanion> products,
  List<HomeSectionsCompanion> sections,
  List<HomeSectionProductsCompanion> memberships,
});

CatalogSeed parseCatalogSeed(String source) {
  final decoded = jsonDecode(source);
  if (decoded case {
    'products': final List<Object?> products,
    'sections': final List<Object?> sections,
  } when products.isNotEmpty && sections.isNotEmpty) {
    return _parseRows(products, sections);
  }
  throw const FormatException('Catalog seed needs products and sections.');
}

CatalogSeed _parseRows(List<Object?> products, List<Object?> sections) {
  // Reject broken links and duplicate IDs before any database writes.
  final productRows = products.map(_parseProduct).toList();
  final productIds = productRows.map((row) => row.id.value).toSet();
  final sectionRows = <HomeSectionsCompanion>[];
  final memberships = <HomeSectionProductsCompanion>[];
  for (final (position, section) in sections.indexed) {
    _parseSection(section, position, productIds, sectionRows, memberships);
  }
  final sectionIds = sectionRows.map((row) => row.id.value).toSet();
  if (productIds.length != productRows.length ||
      sectionIds.length != sectionRows.length) {
    throw const FormatException('Catalog seed IDs must be unique.');
  }
  return (
    products: productRows,
    sections: sectionRows,
    memberships: memberships,
  );
}

ProductsCompanion _parseProduct(Object? value) {
  if (value
      case {
        'id': final String id,
        'code': final String code,
        'name': final String name,
        'description': final String description,
        'priceMmk': final int priceMmk,
        'isNew': final bool isNew,
        'discountPercent': final int? discountPercent,
        'imageAsset': final String imageAsset,
      }
      when priceMmk > 0 &&
          _isValidDiscount(discountPercent) &&
          [id, code, name, description, imageAsset].every(_hasText)) {
    return ProductsCompanion.insert(
      id: id,
      code: code,
      name: name,
      description: description,
      priceMmk: priceMmk,
      isNew: isNew,
      discountPercent: Value(discountPercent),
      imageAsset: imageAsset,
    );
  }
  throw const FormatException('Invalid product in catalog seed.');
}

void _parseSection(
  Object? value,
  int position,
  Set<String> knownProducts,
  List<HomeSectionsCompanion> sections,
  List<HomeSectionProductsCompanion> memberships,
) {
  if (value
      case {
        'id': final String id,
        'title': final String title,
        'productIds': final List<Object?> productIds,
      }
      when _hasText(id) &&
          _hasText(title) &&
          productIds.every(knownProducts.contains) &&
          productIds.toSet().length == productIds.length) {
    sections.add(
      HomeSectionsCompanion.insert(id: id, title: title, position: position),
    );
    // Preserve the fixture's product order independently for each section.
    for (final (productPosition, productId)
        in productIds.cast<String>().indexed) {
      memberships.add(
        HomeSectionProductsCompanion.insert(
          sectionId: id,
          productId: productId,
          position: productPosition,
        ),
      );
    }
    return;
  }
  throw const FormatException(
    'Invalid section or product link in catalog seed.',
  );
}

bool _hasText(String value) => value.trim().isNotEmpty;

bool _isValidDiscount(int? value) =>
    value == null || (value > 0 && value <= _maximumDiscountPercent);
