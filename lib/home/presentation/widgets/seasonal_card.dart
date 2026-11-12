import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../../core/widgets/pill_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';

class SeasonalCard extends StatelessWidget {
  const SeasonalCard({super.key, required this.product, required this.onTap});

  static const _width = 228.0;
  static const _imageAspectRatio = 1.5;
  static const _assetCacheWidth = 800;
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final discount = product.discountPercent;
    return SizedBox(
      width: _width,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.homeProductCardRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: _imageAspectRatio,
              child: ClipRRect(
                borderRadius: AppTheme.homeProductCardRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CatalogImage(
                      assetPath: product.imageAsset,
                      imageUrl: product.imageUrl,
                      assetCacheWidth: _assetCacheWidth,
                    ),
                    // Overlay the discount without reducing the image area.
                    if (discount != null)
                      PositionedDirectional(
                        bottom: 8,
                        end: 8,
                        child: PillBadge(
                          label: l10n.productDiscount(discount),
                          backgroundColor: AppTheme.orangeBadgeBackground,
                          foregroundColor: AppTheme.orangeBadgeForeground,
                          borderColor: AppTheme.orangeBadgeForeground,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(product.name, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
