import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/catalog_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../../product/presentation/product_detail_screen.dart';
import '../../domain/home_repository.dart';

class HomeCatalogSection extends StatelessWidget {
  const HomeCatalogSection({super.key, required this.section});

  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: Theme.of(context).textTheme.titleLarge),
        if (section.products.isEmpty) Text(l10n.homeCatalogEmpty),
        for (final product in section.products) _ProductTile(product: product),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  static const _thumbnailSize = 56.0;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final discount = product.discountPercent;
    return Card(
      child: ListTile(
        leading: SizedBox.square(
          dimension: _thumbnailSize,
          child: CatalogImage(
            assetPath: product.imageAsset,
            imageUrl: product.imageUrl,
          ),
        ),
        title: Text(product.name),
        subtitle: discount == null
            ? null
            : Text(l10n.productDiscount(discount)),
        // Route with the selected record's ID so Detail can query it directly.
        onTap: () => context.pushNamed(
          ProductDetailScreen.routeName,
          pathParameters: {'id': product.id},
        ),
      ),
    );
  }
}
