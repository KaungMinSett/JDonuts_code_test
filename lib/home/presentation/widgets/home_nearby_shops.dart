import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/catalog_image.dart';
import '../../../l10n/app_localizations.dart';
import '../home_providers.dart';
import 'home_section_state.dart';

const _thumbnailSize = 56.0;

class HomeNearbyShops extends ConsumerWidget {
  const HomeNearbyShops({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.homeNearbyShopsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        HomeSectionState(
          state: ref.watch(homeNearbyShopsProvider),
          onRetry: () => ref.invalidate(homeNearbyShopsProvider),
          builder: (shops) => Column(
            children: [
              if (shops.isEmpty) Text(l10n.homeNearbyShopsEmpty),
              for (final shop in shops)
                Card(
                  child: ListTile(
                    leading: SizedBox.square(
                      dimension: _thumbnailSize,
                      child: CatalogImage(assetPath: shop.imageAsset),
                    ),
                    title: Text(shop.name),
                    subtitle: Text(shop.location),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
