import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final style = IconButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      iconSize: 18,
      visualDensity: VisualDensity.compact,
    );
    return Material(
      color: AppTheme.catalogBackground,
      shape: const StadiumBorder(
        side: BorderSide(color: AppTheme.productCardSurface, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            IconButton.filled(
              onPressed: onDecrease,
              tooltip: l10n.productDecreaseQuantity,
              style: style,
              icon: const Icon(Icons.remove),
            ),
            // Swap the number with a short fade and honor Reduce Motion.
            AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : AppMotion.productQuantityChangeDuration,
              child: Text(
                MaterialLocalizations.of(context).formatDecimal(quantity),
                key: ValueKey(quantity),
                style: theme.textTheme.titleLarge,
              ),
            ),
            IconButton.filled(
              onPressed: onIncrease,
              tooltip: l10n.productIncreaseQuantity,
              style: style,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
