import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_theme.dart';
import '../../core/domain/result.dart';
import '../../core/widgets/catalog_load_error.dart';
import '../../l10n/app_localizations.dart';
import 'home_providers.dart';
import 'widgets/home_catalog_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.homeTitle)),
      body: const _HomeCatalog(),
    );
  }
}

class _HomeCatalog extends ConsumerWidget {
  const _HomeCatalog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sections = ref.watch(homeSectionsProvider);
    final loadError = CatalogLoadError(
      onRetry: () => ref.invalidate(homeSectionsProvider),
    );

    // Only the catalog body rebuilds when the local query emits.
    return switch (sections) {
      AsyncData(value: Success(value: final data)) when data.isNotEmpty =>
        ListView(
          padding: AppTheme.catalogContentPadding,
          children: [
            for (final section in data) HomeCatalogSection(section: section),
          ],
        ),
      AsyncData(value: Success()) => Center(child: Text(l10n.homeCatalogEmpty)),
      AsyncData(value: Failure()) || AsyncError() => loadError,
      _ => Center(child: Text(l10n.catalogLoading)),
    };
  }
}
