import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_theme.dart';
import '../../core/domain/result.dart';
import '../../core/widgets/catalog_image.dart';
import '../../core/widgets/catalog_load_error.dart';
import '../../l10n/app_localizations.dart';
import '../domain/product.dart';
import 'product_providers.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  static const routeName = 'product';
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.productTitle)),
      body: _ProductDetails(productId: productId),
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

class _ProductContent extends StatelessWidget {
  const _ProductContent({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: AppTheme.catalogContentPadding,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CatalogImage(assetPath: product.imageAsset),
        ),
        Text(product.code, style: textTheme.labelLarge),
        Text(product.name, style: textTheme.headlineSmall),
        if (product.isNew) Text(l10n.productNewBadge),
        Text(
          l10n.productPriceMmk(product.priceMmk),
          style: textTheme.titleLarge,
        ),
        Text(product.description),
      ],
    );
  }
}
