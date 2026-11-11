import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class CatalogLoadError extends StatelessWidget {
  const CatalogLoadError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.catalogLoadError),
          TextButton(onPressed: onRetry, child: Text(l10n.catalogRetry)),
        ],
      ),
    );
  }
}
