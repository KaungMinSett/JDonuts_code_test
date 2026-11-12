import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../../product/presentation/product_detail_screen.dart';
import '../../domain/home_repository.dart';
import '../home_providers.dart';
import 'home_product_card.dart';
import 'home_section_header.dart';
import 'home_section_state.dart';
import 'home_skeleton.dart';
import 'seasonal_card.dart';

class HomeProductSections extends ConsumerWidget {
  const HomeProductSections({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return HomeSectionState(
      state: ref.watch(homeSectionsProvider),
      onRetry: () => ref.invalidate(homeSectionsProvider),
      loading: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppTheme.homeSectionTitleSpacing,
        children: [
          HomeSkeletonBlock(width: 142, height: 24),
          Row(
            spacing: 12,
            children: [
              Expanded(child: HomeSkeletonBlock(height: 152, radius: 16)),
              Expanded(child: HomeSkeletonBlock(height: 152, radius: 16)),
            ],
          ),
          HomeSkeletonBlock(width: 114, height: 14),
        ],
      ),
      builder: (sections) => sections.isEmpty
          ? Text(l10n.homeCatalogEmpty)
          : _HomeProductRows(sections: sections),
    );
  }
}

class _HomeProductRows extends StatefulWidget {
  const _HomeProductRows({required this.sections});

  final List<HomeSection> sections;

  @override
  State<_HomeProductRows> createState() => _HomeProductRowsState();
}

class _HomeProductRowsState extends State<_HomeProductRows>
    with SingleTickerProviderStateMixin {
  late final _entrance = AnimationController(
    vsync: this,
    duration: AppMotion.homeSectionEntranceDuration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The rows only mount after the first successful catalog read.
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed && !_entrance.isAnimating) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppTheme.homeSectionSpacing,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, section) in widget.sections.indexed)
          _HomeSectionEntrance(
            key: ValueKey(section.id),
            progress: _entrance.drive(
              CurveTween(
                curve: AppMotion.homeSectionEntranceInterval(
                  index,
                  widget.sections.length,
                ),
              ),
            ),
            child: HomeCatalogSection(section: section),
          ),
      ],
    );
  }
}

class _HomeSectionEntrance extends StatelessWidget {
  const _HomeSectionEntrance({
    super.key,
    required this.progress,
    required this.child,
  });

  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Fade and lift this row within its window of the shared timeline.
    return SlideTransition(
      position: progress.drive(
        Tween(
          begin: const Offset(0, AppMotion.homeSectionSlideFraction),
          end: Offset.zero,
        ),
      ),
      child: FadeTransition(opacity: progress, child: child),
    );
  }
}

class HomeCatalogSection extends StatelessWidget {
  const HomeCatalogSection({super.key, required this.section});

  static const _seasonalSectionId = 'seasonal';
  static const _popularSectionId = 'popular';
  static const _orderAgainSectionId = 'order_again';
  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = section.id == _popularSectionId
        ? '${section.title} 🔥'
        : section.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeader(title: title),
        const SizedBox(height: AppTheme.homeSectionTitleSpacing),
        if (section.products.isEmpty)
          Text(l10n.homeCatalogEmpty)
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final product in section.products)
                  _buildCard(context, product),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Product product) {
    void openProduct() {
      // Pass the ID so Detail reads the same record from the database.
      context.pushNamed(
        ProductDetailScreen.routeName,
        pathParameters: {'id': product.id},
      );
    }

    return switch (section.id) {
      _seasonalSectionId => SeasonalCard(product: product, onTap: openProduct),
      _orderAgainSectionId => HomeProductCard.orderAgain(
        product: product,
        onTap: openProduct,
      ),
      _ => HomeProductCard.popular(product: product, onTap: openProduct),
    };
  }
}
