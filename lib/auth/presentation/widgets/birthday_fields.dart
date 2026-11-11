import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';

class BirthdayFields extends StatelessWidget {
  const BirthdayFields({
    required this.birthday,
    required this.onTap,
    this.errorText,
    super.key,
  });

  final DateTime? birthday;
  final VoidCallback? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final date = birthday;

    // All rows display one date and invoke the same picker.
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BirthdayField(
          label: strings.birthdayMonth,
          value: date == null ? null : DateFormat.MMMM(locale).format(date),
          onTap: onTap,
        ),
        _BirthdayField(
          label: strings.birthdayDay,
          value: date == null ? null : DateFormat.d(locale).format(date),
          onTap: onTap,
        ),
        _BirthdayField(
          label: strings.birthdayYear,
          value: date == null ? null : DateFormat.y(locale).format(date),
          onTap: onTap,
          errorText: errorText,
        ),
      ],
    );
  }
}

class _BirthdayField extends StatelessWidget {
  const _BirthdayField({
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final String? value;
  final VoidCallback? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      value: value,
      hint: errorText,
      child: InkWell(
        onTap: onTap,
        child: ExcludeSemantics(
          // Reuse the text field appearance without opening a keyboard.
          child: InputDecorator(
            isEmpty: value == null,
            decoration: InputDecoration(
              hintText: label,
              errorText: errorText,
              errorMaxLines: 3,
            ).applyDefaults(theme.inputDecorationTheme),
            child: Text(value ?? '', style: theme.textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }
}
