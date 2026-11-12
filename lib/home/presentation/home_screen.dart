import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/app_theme.dart';
import '../../app/network/reachability_providers.dart';
import '../../core/domain/result.dart';
import '../../l10n/app_localizations.dart';
import '../../rewards/presentation/rewards_screen.dart';
import '../../settings/presentation/widgets/sign_out_button.dart';
import 'home_providers.dart';
import 'widgets/home_catalog_section.dart';
import 'widgets/home_header_section.dart';
import 'widgets/home_nearby_shops.dart';
import 'widgets/home_offline_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.catalogBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Continue the header color through the status bar.
            ColoredBox(
              color: AppTheme.homeHeaderBackground,
              child: SafeArea(bottom: false, child: HomeOfflineBanner()),
            ),
            Expanded(child: _HomeCatalog()),
          ],
        ),
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
    // Refresh on the first online result and each offline-to-online change.
    ref.listen(isOnlineProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        unawaited(ref.read(homeRepositoryProvider).refreshCatalog());
      }
    });

    // Each section watches its own query inside the shared scroll view.
    return RefreshIndicator(
      onRefresh: () => _refreshFromPull(context, ref),
      child: ListView(
        // Accept refresh drags while keeping content against the header.
        physics: const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.zero,
        children: const [
          HomeHeaderSection(),
          SafeArea(
            top: false,
            bottom: false,
            minimum: AppTheme.catalogContentPadding,
            child: HomeProductSections(),
          ),
          HomeNearbyShops(),
          SafeArea(
            top: false,
            minimum: AppTheme.catalogContentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppTheme.homeSectionTitleSpacing,
              children: [_RewardsLink(), SignOutButton()],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardsLink extends StatelessWidget {
  const _RewardsLink();

  @override
  Widget build(BuildContext context) {
    // Keep Rewards reachable for verification until the tab bar is wired.
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => context.pushNamed(RewardsScreen.routeName),
      child: Text(AppLocalizations.of(context)!.rewardsLabel),
    );
  }
}
