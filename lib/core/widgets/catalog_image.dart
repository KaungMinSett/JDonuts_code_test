import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.assetPath,
    this.imageUrl,
    this.assetCacheWidth,
    this.fit = BoxFit.cover,
  });

  final String assetPath;
  final String? imageUrl;
  final int? assetCacheWidth;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bundledImage = Image.asset(
      assetPath,
      fit: fit,
      cacheWidth: assetCacheWidth,
      // Keep the tile usable if its bundled image cannot be decoded.
      errorBuilder: (_, _, _) => Center(
        child: Text(AppLocalizations.of(context)!.catalogImageUnavailable),
      ),
    );
    final url = imageUrl;
    if (url == null) return bundledImage;

    // Let the plugin check disk first, even if the device is offline.
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      // Keep the placeholder neutral while the disk cache is being read.
      placeholder: (context, _) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (_, _, _) => bundledImage,
    );
  }
}
