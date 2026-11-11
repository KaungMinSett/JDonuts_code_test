import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/otp_validator.dart';

class OtpCodeInput extends StatelessWidget {
  const OtpCodeInput({
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.hasError = false,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // One editable field lets the keyboard paste or autofill the whole code.
        Positioned.fill(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            readOnly: readOnly,
            onChanged: onChanged,
            onTap: () {
              // Tapping any box continues entry at the end of the code.
              controller.selection = TextSelection.collapsed(
                offset: controller.text.length,
              );
            },
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(otpCodeLength),
            ],
            autocorrect: false,
            enableSuggestions: false,
            showCursor: false,
            style: const TextStyle(color: Colors.transparent),
            // The six boxes draw the focus outline. Override the shared field borders.
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
              hintText: strings.otpInputLabel,
              hintStyle: const TextStyle(color: Colors.transparent),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
        // The boxes display the code without intercepting taps or repeating it
        // to screen readers.
        IgnorePointer(
          child: ExcludeSemantics(
            child: _OtpDigitRow(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled && !readOnly,
              hasError: hasError,
            ),
          ),
        ),
      ],
    );
  }
}

class _OtpDigitRow extends StatelessWidget {
  const _OtpDigitRow({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hasError,
  });

  static const _boxSpacing = 8.0;

  final bool hasError;

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller, focusNode]),
      builder: (context, _) {
        final code = controller.text;
        final hasFocus = enabled && focusNode.hasFocus;
        return Row(
          textDirection: TextDirection.ltr,
          spacing: _boxSpacing,
          children: List.generate(otpCodeLength, (index) {
            // The active box follows the next digit as users type or delete.
            return Expanded(
              child: _OtpDigitBox(
                digit: index < code.length ? code[index] : '',
                isActive: hasFocus && index == code.length,
                hasError: hasError,
              ),
            );
          }),
        );
      },
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.digit,
    required this.isActive,
    required this.hasError,
  });

  static const _minHeight = 56.0;
  static const _radius = BorderRadius.all(Radius.circular(8));

  final String digit;
  final bool isActive;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final borderColor = switch ((hasError, isActive)) {
      (true, _) => theme.colorScheme.error,
      (_, true) => theme.colorScheme.secondary,
      _ => Colors.transparent,
    };

    return AnimatedContainer(
      duration: reduceMotion ? Duration.zero : AppMotion.otpBoxFocusDuration,
      curve: AppMotion.otpBoxFocusCurve,
      constraints: const BoxConstraints(minHeight: _minHeight),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.authControlSurface,
        borderRadius: _radius,
        border: Border.all(color: borderColor),
      ),
      child: Text(digit, style: theme.textTheme.headlineSmall),
    );
  }
}
