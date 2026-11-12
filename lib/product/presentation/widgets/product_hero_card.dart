import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/pill_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/product.dart';

class ProductHeroCard extends StatelessWidget {
  const ProductHeroCard({
    super.key,
    required this.product,
    required this.image,
  });

  final Product product;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.productCardSurface,
        borderRadius: AppTheme.productCardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        product.code,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        product.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        l10n.productPriceMmk(product.priceMmk),
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                if (product.isNew) ...[
                  const SizedBox(width: 8),
                  PillBadge(
                    label: l10n.productNewBadge,
                    backgroundColor: AppTheme.orangeBadgeBackground,
                    foregroundColor: AppTheme.orangeBadgeForeground,
                  ),
                ],
              ],
            ),
            // Give the parent-supplied image a stable area as text grows above it.
            AspectRatio(
              aspectRatio: 1.25,
              child: Padding(padding: const EdgeInsets.all(12), child: image),
            ),
          ],
        ),
      ),
    );
  }
}
