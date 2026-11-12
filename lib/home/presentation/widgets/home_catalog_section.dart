import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/catalog_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../../product/presentation/product_detail_screen.dart';
import '../../domain/home_repository.dart';
import '../home_providers.dart';
import 'home_section_header.dart';
import 'home_section_state.dart';
import 'seasonal_card.dart';

class HomeProductSections extends ConsumerWidget {
  const HomeProductSections({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return HomeSectionState(
      state: ref.watch(homeSectionsProvider),
      onRetry: () => ref.invalidate(homeSectionsProvider),
      builder: (sections) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (sections.isEmpty) Text(l10n.homeCatalogEmpty),
          for (final section in sections) HomeCatalogSection(section: section),
        ],
      ),
    );
  }
}

class HomeCatalogSection extends StatelessWidget {
  const HomeCatalogSection({super.key, required this.section});

  static const _seasonalSectionId = 'seasonal';
  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeSectionHeader(title: section.title),
          if (section.products.isEmpty)
            Text(l10n.homeCatalogEmpty)
          else if (section.id == _seasonalSectionId)
            _SeasonalProductRow(products: section.products)
          else
            for (final product in section.products) _ProductTile(product: product),
        ],
      ),
    );
  }
}

class _SeasonalProductRow extends StatelessWidget {
  const _SeasonalProductRow({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final product in products)
            SeasonalCard(
              product: product,
              onTap: () => _openProduct(context, product.id),
            ),
        ],
      ),
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
        onTap: () => _openProduct(context, product.id),
      ),
    );
  }
}

void _openProduct(BuildContext context, String productId) {
  // Pass the ID so Detail reads the same record from the database.
  context.pushNamed(
    ProductDetailScreen.routeName,
    pathParameters: {'id': productId},
  );
}
