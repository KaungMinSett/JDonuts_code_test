import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../../core/widgets/pill_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/home_repository.dart';
import '../home_providers.dart';
import 'home_section_state.dart';
import 'home_skeleton.dart';

class HomeBannerCarousel extends ConsumerWidget {
  const HomeBannerCarousel({super.key});

  static const _height = 180.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: _height,
      child: HomeSectionState(
        state: ref.watch(homeBannersProvider),
        onRetry: () => ref.invalidate(homeBannersProvider),
        loading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.homeHeaderGutter),
          child: HomeSkeletonBlock(radius: 16),
        ),
        builder: (banners) => switch (banners.length) {
          0 => Center(child: Text(l10n.homeBannersEmpty)),
          1 => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.homeHeaderGutter,
            ),
            child: _HomeBannerCard(banner: banners.first),
          ),
          _ => _LoopingBannerPages(banners: banners),
        },
      ),
    );
  }
}

class _LoopingBannerPages extends StatefulWidget {
  const _LoopingBannerPages({required this.banners});

  final List<HomeBanner> banners;

  @override
  State<_LoopingBannerPages> createState() => _LoopingBannerPagesState();
}

class _LoopingBannerPagesState extends State<_LoopingBannerPages> {
  static const _startingCycle = 1000;
  static const _viewportFraction = 0.76;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Start on the first banner with enough pages to swipe backward as well.
    _pageController = PageController(
      initialPage: widget.banners.length * _startingCycle,
      viewportFraction: _viewportFraction,
      keepPage: false,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, page) {
        // Center the selected card with an even peek at either neighbor.
        final index = page % banners.length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: _HomeBannerCard(banner: banners[index]),
        );
      },
    );
  }
}

class _HomeBannerCard extends StatelessWidget {
  const _HomeBannerCard({required this.banner});

  static const _assetCacheWidth = 1000;
  final HomeBanner banner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppTheme.homeBannerRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Semantics(
            image: true,
            label: banner.title,
            child: CatalogImage(
              assetPath: banner.imageAsset,
              assetCacheWidth: _assetCacheWidth,
            ),
          ),
          // Paint the badge over the image without reserving a separate title row.
          PositionedDirectional(
            top: 10,
            start: 10,
            child: PillBadge(
              label: banner.badgeLabel,
              backgroundColor: AppTheme.orangeBadgeBackground,
              foregroundColor: AppTheme.orangeBadgeForeground,
              borderColor: AppTheme.orangeBadgeForeground,
            ),
          ),
        ],
      ),
    );
  }
}
