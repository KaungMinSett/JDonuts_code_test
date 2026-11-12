import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';
import 'pill_badge.dart';

class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      // Round the leading edge so the other edge can sit flush with the screen.
      decoration: const BoxDecoration(
        color: AppTheme.orangeBadgeBackground,
        borderRadius: BorderRadiusDirectional.horizontal(
          start: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 8, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme.merge(
              data: const IconThemeData(
                color: AppTheme.orangeBadgeForeground,
                size: 18,
              ),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: AppTheme.orangeBadgeForeground),
                child: child,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 5),
              PillBadge(
                label: MaterialLocalizations.of(context).formatDecimal(count),
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
