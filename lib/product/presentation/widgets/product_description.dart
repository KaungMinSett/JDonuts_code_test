import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        SizedBox(
          width: 62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              const Icon(
                Icons.help,
                color: AppTheme.productDescriptionAccent,
                size: 16,
              ),
              Text(
                AppLocalizations.of(context)!.productDescriptionTitle,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: DecoratedBox(
            // Let the divider follow the description as it wraps.
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Text(description, style: theme.textTheme.bodyMedium),
            ),
          ),
        ),
      ],
    );
  }
}
