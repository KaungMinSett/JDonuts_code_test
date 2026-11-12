import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../../core/widgets/pill_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';

class HomeProductCard extends StatelessWidget {
  const HomeProductCard.popular({
    super.key,
    required this.product,
    required this.onTap,
  }) : _imageAspectRatio = 2 / 3,
       _showDiscount = false;

  const HomeProductCard.orderAgain({
    super.key,
    required this.product,
    required this.onTap,
  }) : _imageAspectRatio = 1,
       _showDiscount = true;

  static const _width = 160.0;
  final Product product;
  final VoidCallback onTap;
  final double _imageAspectRatio;
  final bool _showDiscount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final discount = _showDiscount ? product.discountPercent : null;
    return SizedBox(
      width: _width,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.productCardRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            AspectRatio(
              aspectRatio: _imageAspectRatio,
              child: ClipRRect(
                borderRadius: AppTheme.productCardRadius,
                child: ColoredBox(
                  color: AppTheme.productCardSurface,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Keep the whole product visible on the white surface.
                      CatalogImage(
                        assetPath: product.imageAsset,
                        imageUrl: product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                      if (discount != null)
                        PositionedDirectional(
                          end: 8,
                          bottom: 8,
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
            ),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
