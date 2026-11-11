import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class BirthdayPickerSheet extends StatefulWidget {
  const BirthdayPickerSheet({
    required this.initialDate,
    required this.latestDate,
    super.key,
  });

  final DateTime initialDate;
  final DateTime latestDate;

  @override
  State<BirthdayPickerSheet> createState() => _BirthdayPickerSheetState();
}

class _BirthdayPickerSheetState extends State<BirthdayPickerSheet> {
  static const _wheelHeight = 216.0;

  late DateTime _draftBirthday = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final materialStrings = MaterialLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(materialStrings.cancelButtonLabel),
                ),
                Expanded(
                  child: Text(
                    strings.birthdayPickerTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(_draftBirthday),
                  child: Text(strings.birthdayPickerDone),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _wheelHeight,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: widget.initialDate,
              maximumDate: widget.latestDate,
              maximumYear: widget.latestDate.year,
              // Keep wheel changes local until Done confirms all three parts.
              onDateTimeChanged: (date) => _draftBirthday = date,
            ),
          ),
        ],
      ),
    );
  }
}
