import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/network/reachability_providers.dart';
import '../../../l10n/app_localizations.dart';

class HomeOfflineBanner extends ConsumerWidget {
  const HomeOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the catalog subtree independent of reachability updates.
    if (ref.watch(isOnlineProvider).value != false) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            AppLocalizations.of(context)!.homeOffline,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
