import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.center,
    this.leadingText,
    this.errorText,
    this.error,
    this.enabled = true,
    super.key,
  });

  static const _leadingPadding = EdgeInsetsDirectional.only(start: 16, end: 8);

  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final String? leadingText;
  final String? errorText;
  final Widget? error;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefix = leadingText;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      keyboardType: keyboardType,
      enabled: enabled,
      textAlign: textAlign,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        error: error,
        errorMaxLines: 3,
        // The leading text stays visible when the field is empty and unfocused.
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: _leadingPadding,
                child: Text(
                  prefix,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
      ),
    );
  }
}
