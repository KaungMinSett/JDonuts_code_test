import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      builder: (sections) => Column(
        spacing: AppTheme.homeSectionSpacing,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (sections.isEmpty) Text(l10n.homeCatalogEmpty),
          for (final section in sections) HomeCatalogSection(section: section),
        ],
      ),
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
