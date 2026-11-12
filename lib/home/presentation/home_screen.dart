import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_theme.dart';
import '../../app/network/reachability_providers.dart';
import '../../core/domain/result.dart';
import '../../core/widgets/catalog_load_error.dart';
import '../../l10n/app_localizations.dart';
import 'home_providers.dart';
import 'widgets/home_catalog_section.dart';
import 'widgets/home_offline_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.homeTitle)),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeOfflineBanner(),
          Expanded(child: _HomeCatalog()),
        ],
      ),
    );
  }
}

class _HomeCatalog extends ConsumerWidget {
  const _HomeCatalog();

  Future<void> _refreshFromPull(BuildContext context, WidgetRef ref) async {
    final reachability = ref.read(internetReachabilityProvider);
    final repository = ref.read(homeRepositoryProvider);
    final l10n = AppLocalizations.of(context)!;
    var message = l10n.catalogRefreshOffline;

    // Check again on a pull because the last status may be out of date.
    if (await reachability.isOnline()) {
      if (await repository.refreshCatalog() is Success) return;
      message = l10n.catalogRefreshFailed;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sections = ref.watch(homeSectionsProvider);
    final loadError = CatalogLoadError(
      onRetry: () => ref.invalidate(homeSectionsProvider),
    );

    // Refresh on the first online result and each offline-to-online change.
    ref.listen(isOnlineProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        unawaited(ref.read(homeRepositoryProvider).refreshCatalog());
      }
    });

    // Only the catalog body rebuilds when the local query emits.
    return switch (sections) {
      AsyncData(value: Success(value: final data)) => RefreshIndicator(
        onRefresh: () => _refreshFromPull(context, ref),
        child: ListView(
          // Allow a pull even when the starter catalog fits on one screen.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppTheme.catalogContentPadding,
          children: [
            if (data.isEmpty) Text(l10n.homeCatalogEmpty),
            for (final section in data) HomeCatalogSection(section: section),
          ],
        ),
      ),
      AsyncData(value: Failure()) || AsyncError() => loadError,
      _ => Center(child: Text(l10n.catalogLoading)),
    };
  }
}
