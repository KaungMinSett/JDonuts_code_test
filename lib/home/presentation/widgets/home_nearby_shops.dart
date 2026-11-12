import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/pill_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/home_repository.dart';
import '../home_providers.dart';
import 'home_section_state.dart';
import 'home_skeleton.dart';
import 'nearby_shop_card.dart';

class HomeNearbyShops extends ConsumerWidget {
  const HomeNearbyShops({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = HomeSectionState(
      state: ref.watch(homeNearbyShopsProvider),
      onRetry: () => ref.invalidate(homeNearbyShopsProvider),
      loading: const Padding(
        padding: AppTheme.catalogContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppTheme.homeSectionTitleSpacing,
          children: [
            HomeSkeletonBlock(width: 240, height: 24),
            HomeSkeletonBlock(width: 112, height: 28, radius: 14),
            HomeSkeletonBlock(
              width: NearbyShopCard.width,
              height: 256,
              radius: 16,
            ),
          ],
        ),
      ),
      builder: (shops) => _NearbyShopsContent(shops: shops),
    );
    // Keep the bar clearance inside the cyan section so it reaches the strip.
    return ColoredBox(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(top: false, child: section),
    );
  }
}

class _NearbyShopsContent extends StatelessWidget {
  const _NearbyShopsContent({required this.shops});

  final List<NearbyShop> shops;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (shops.isEmpty) {
      return Padding(
        padding: AppTheme.catalogContentPadding,
        child: Text(l10n.homeNearbyShopsEmpty),
      );
    }

    final horizontalPadding = AppTheme.catalogContentPadding.copyWith(
      top: 0,
      bottom: 0,
    );
    return Padding(
      padding: AppTheme.catalogContentPadding.copyWith(left: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppTheme.homeSectionTitleSpacing,
        children: [
          Padding(
            padding: horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppTheme.homeSectionTitleSpacing,
              children: [
                Text(
                  l10n.homeNearbyShopCount(shops.length),
                  style: theme.textTheme.titleLarge,
                ),
                // The brief treats this as a display-only label.
                PillBadge(
                  label: l10n.homeNearbyShopsExplore,
                  backgroundColor: AppTheme.productCardSurface,
                  foregroundColor: AppTheme.nearbyShopsExploreText,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // Let the card gutters scroll with the row across the full width.
            padding: horizontalPadding,
            child: Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final shop in shops) NearbyShopCard(shop: shop)],
            ),
          ),
        ],
      ),
    );
  }
}
