import 'dart:convert';

import 'package:drift/drift.dart';

import 'catalog_database.dart';

const _maximumDiscountPercent = 100;

typedef CatalogSeed = ({
  List<ProductsCompanion> products,
  List<HomeSectionsCompanion> sections,
  List<HomeSectionProductsCompanion> memberships,
  MembersCompanion member,
  List<HomeBannersCompanion> banners,
  List<NearbyShopsCompanion> shops,
});

CatalogSeed parseCatalogSeed(String source) {
  final decoded = jsonDecode(source);
  if (decoded case {
    'products': final List<Object?> products,
    'sections': final List<Object?> sections,
    'member': final Object? member,
    'banners': final List<Object?> banners,
    'shops': final List<Object?> shops,
  } when products.isNotEmpty && sections.isNotEmpty) {
    return _parseRows(
      products,
      sections,
      member: _parseMember(member),
      banners: [
        for (final (position, banner) in banners.indexed)
          _parseBanner(banner, position),
      ],
      shops: [
        for (final (position, shop) in shops.indexed)
          _parseShop(shop, position),
      ],
    );
  }
  throw const FormatException('Catalog seed needs Home data.');
}

({String productId, int discountPercent}) parseCatalogDiscountUpdate(
  String source,
) {
  if (jsonDecode(source) case {
    'productId': final String productId,
    'discountPercent': final int discountPercent,
  } when _hasText(productId) && _isValidDiscount(discountPercent)) {
    return (productId: productId, discountPercent: discountPercent);
  }
  throw const FormatException('Invalid catalog discount update.');
}

CatalogSeed _parseRows(
  List<Object?> products,
  List<Object?> sections, {
  required MembersCompanion member,
  required List<HomeBannersCompanion> banners,
  required List<NearbyShopsCompanion> shops,
}) {
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
    member: member,
    banners: banners,
    shops: shops,
  );
}

MembersCompanion _parseMember(Object? value) {
  if (value
      case {
        'id': final String id,
        'name': final String name,
        'imageAsset': final String imageAsset,
        'tier': final String tier,
        'points': final int points,
        'nextTier': final String nextTier,
        'nextTierPoints': final int nextTierPoints,
        'notificationCount': final int notificationCount,
      }
      when points >= 0 &&
          nextTierPoints > points &&
          notificationCount >= 0 &&
          [id, name, imageAsset, tier, nextTier].every(_hasText)) {
    return MembersCompanion.insert(
      id: id,
      name: name,
      imageAsset: imageAsset,
      tier: tier,
      points: points,
      nextTier: nextTier,
      nextTierPoints: nextTierPoints,
      notificationCount: notificationCount,
    );
  }
  throw const FormatException('Invalid member in catalog seed.');
}

HomeBannersCompanion _parseBanner(Object? value, int position) {
  if (value case {
    'id': final String id,
    'title': final String title,
    'badgeLabel': final String badgeLabel,
    'imageAsset': final String imageAsset,
  } when [id, title, badgeLabel, imageAsset].every(_hasText)) {
    return HomeBannersCompanion.insert(
      id: id,
      title: title,
      badgeLabel: badgeLabel,
      imageAsset: imageAsset,
      position: position,
    );
  }
  throw const FormatException('Invalid banner in catalog seed.');
}

NearbyShopsCompanion _parseShop(Object? value, int position) {
  if (value case {
    'id': final String id,
    'name': final String name,
    'location': final String location,
    'imageAsset': final String imageAsset,
  } when [id, name, location, imageAsset].every(_hasText)) {
    return NearbyShopsCompanion.insert(
      id: id,
      name: name,
      location: location,
      imageAsset: imageAsset,
      position: position,
    );
  }
  throw const FormatException('Invalid shop in catalog seed.');
}

ProductsCompanion _parseProduct(Object? value) {
  if (value
      case final Map<String, Object?> product &&
          {
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
      imageUrl: Value(_parseImageUrl(product['imageUrl'])),
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

String? _parseImageUrl(Object? value) {
  // Products can rely entirely on their bundled artwork.
  if (value == null) return null;
  if (value is String) {
    final uri = Uri.tryParse(value);
    if (uri != null && uri.scheme == 'https' && uri.host.isNotEmpty) {
      return value;
    }
  }
  throw const FormatException('Product image URL must be HTTPS.');
}
