import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/config/app_motion.dart';


class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.loadingLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? loadingLabel;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  static const _loadingIndicatorSize = 20.0;

  final _buttonStates = WidgetStatesController();
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _buttonStates.addListener(_updatePressedState);
  }

  @override
  void dispose() {
    _buttonStates.dispose();
    super.dispose();
  }

  void _updatePressedState() {
    if (_buttonStates.value.contains(WidgetState.pressed) == _pressed) return;

    // Material can notify during build, so update the scale after that frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final pressed = _buttonStates.value.contains(WidgetState.pressed);
      if (pressed != _pressed) setState(() => _pressed = pressed);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final loadingLabel = widget.loadingLabel;
    final isLoading = loadingLabel != null;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: _pressed && !reduceMotion ? AppMotion.buttonPressedScale : 1,
      duration: reduceMotion ? Duration.zero : AppMotion.buttonPressDuration,
      curve: AppMotion.buttonPressCurve,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          statesController: _buttonStates,
          // Loading disables taps while keeping the button in its active color.
          onPressed: isLoading ? null : widget.onPressed,
          style: isLoading
              ? FilledButton.styleFrom(
                  disabledBackgroundColor: colorScheme.primary,
                  disabledForegroundColor: colorScheme.onPrimary,
                )
              : null,
          child: AnimatedSwitcher(
            duration: reduceMotion
                ? Duration.zero
                : AppMotion.buttonLoadingDuration,
            switchInCurve: AppMotion.buttonLoadingCurve,
            switchOutCurve: AppMotion.buttonLoadingCurve,
            child: loadingLabel != null && !reduceMotion
                ? SizedBox.square(
                    key: const ValueKey('button-loading'),
                    dimension: _loadingIndicatorSize,
                    child: CupertinoActivityIndicator(
                      color: colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    loadingLabel ?? widget.label,
                    key: ValueKey(isLoading),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}
