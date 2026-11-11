import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class CatalogImage extends StatelessWidget {
  const CatalogImage({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      // Keep the tile usable if its bundled image cannot be decoded.
      errorBuilder: (_, _, _) => Center(
        child: Text(AppLocalizations.of(context)!.catalogImageUnavailable),
      ),
    );
  }
}
