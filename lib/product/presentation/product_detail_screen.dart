import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_theme.dart';
import '../../core/domain/result.dart';
import '../../core/widgets/catalog_image.dart';
import '../../core/widgets/catalog_load_error.dart';
import '../../core/widgets/primary_button.dart';
import '../../l10n/app_localizations.dart';
import '../domain/product.dart';
import 'product_providers.dart';
import 'widgets/product_description.dart';
import 'widgets/product_hero_card.dart';
import 'widgets/quantity_stepper.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  static const routeName = 'product';
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.catalogBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.catalogBackground,
        scrolledUnderElevation: 0,
      ),
      body: Semantics(
        namesRoute: true,
        label: AppLocalizations.of(context)!.productTitle,
        child: SafeArea(
          top: false,
          child: _ProductDetails(productId: productId),
        ),
      ),
    );
  }
}

class _ProductDetails extends ConsumerWidget {
  const _ProductDetails({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final query = productDetailsProvider(productId);

    // Handle an unknown ID separately from a catalog read failure.
    return switch (ref.watch(query)) {
      AsyncData(value: Success(value: final Product product)) =>
        _ProductContent(product: product),
      AsyncData(value: Success(value: null)) => Center(
        child: Text(l10n.productNotFound),
      ),
      AsyncData(value: Failure()) ||
      AsyncError() => CatalogLoadError(onRetry: () => ref.invalidate(query)),
      _ => Center(child: Text(l10n.catalogLoading)),
    };
  }
}

class _ProductContent extends StatefulWidget {
  const _ProductContent({required this.product});

  final Product product;

  @override
  State<_ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<_ProductContent> {
  static const _minimumQuantity = 1;
  static const _stepperOverlap = 24.0;
  int _quantity = _minimumQuantity;

  void _showCartFeedback() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            l10n.productAddedToCart(_quantity, widget.product.name),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final product = widget.product;
    final total = l10n.productPriceMmk(product.priceMmk * _quantity);
    return ListView(
      padding: AppTheme.catalogContentPadding,
      children: [
        Stack(
          children: [
            // Reserve space below the card so the stepper stays tappable.
            Padding(
              padding: const EdgeInsets.only(bottom: _stepperOverlap),
              child: ProductHeroCard(
                product: product,
                image: CatalogImage(
                  assetPath: product.imageAsset,
                  imageUrl: product.imageUrl,
                  assetCacheWidth: 800,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: QuantityStepper(
                  quantity: _quantity,
                  onDecrease: _quantity == _minimumQuantity
                      ? null
                      : () => setState(() => _quantity--),
                  onIncrease: () => setState(() => _quantity++),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProductDescription(description: product.description),
        const SizedBox(height: 20),
        PrimaryButton(
          label: l10n.productAddToCart(total),
          onPressed: _showCartFeedback,
        ),
      ],
    );
  }
}
