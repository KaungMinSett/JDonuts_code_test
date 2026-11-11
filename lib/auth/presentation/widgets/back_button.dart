import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';


class BackButton extends StatelessWidget {
  const BackButton({required this.onPressed, super.key});

  static const _buttonSize = Size.square(40);
  static const _arrowSize = 20.0;
  static const _cornerRadius = 8.0;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      style: IconButton.styleFrom(
        backgroundColor: AppTheme.authControlSurface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        fixedSize: _buttonSize,
        iconSize: _arrowSize,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.standard,
        // Keep the touch target larger than the visible button.
        tapTargetSize: MaterialTapTargetSize.padded,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
        ),
      ),
      icon: const Icon(Icons.arrow_back),
    );
  }
}
