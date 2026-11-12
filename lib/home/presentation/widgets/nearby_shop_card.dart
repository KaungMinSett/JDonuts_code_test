import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/home_repository.dart';

class NearbyShopCard extends StatelessWidget {
  const NearbyShopCard({super.key, required this.shop});

  static const width = 280.0;
  static const _imageAspectRatio = 16 / 9;
  static const _assetCacheWidth = 800;
  final NearbyShop shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: width,
      padding: AppTheme.catalogContentPadding,
      decoration: const BoxDecoration(
        color: AppTheme.productCardSurface,
        borderRadius: AppTheme.productCardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppTheme.homeSectionTitleSpacing,
        children: [
          AspectRatio(
            aspectRatio: _imageAspectRatio,
            child: ClipRRect(
              borderRadius: AppTheme.productCardRadius,
              // Use the shop's bundled photo so the card works in airplane mode.
              child: CatalogImage(
                assetPath: shop.imageAsset,
                assetCacheWidth: _assetCacheWidth,
              ),
            ),
          ),
          Text(shop.name, style: theme.textTheme.titleMedium),
          Text(shop.location, style: theme.textTheme.bodyMedium),
          Text(
            l10n.homeNearbyShopsOrderOnline,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppTheme.nearbyShopsOrderText,
            ),
          ),
        ],
      ),
    );
  }
}
