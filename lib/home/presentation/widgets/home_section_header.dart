import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
        IconButton.filled(
          // Keep the visual affordance while section destinations are pending.
          onPressed: () {},
          tooltip: AppLocalizations.of(context)!.homeSectionMore(title),
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            visualDensity: VisualDensity.compact,
          ),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
