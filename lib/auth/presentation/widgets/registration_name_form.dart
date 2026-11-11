import 'package:flutter/material.dart';

import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/name_validator.dart';
import 'app_legal_notice.dart';
import 'input_text_field.dart';

class RegistrationNameForm extends StatefulWidget {
  const RegistrationNameForm({
    required this.header,
    required this.onContinue,
    super.key,
  });

  final Widget header;
  final Future<void> Function(String firstName, String? lastName) onContinue;

  @override
  State<RegistrationNameForm> createState() => _RegistrationNameFormState();
}

class _RegistrationNameFormState extends State<RegistrationNameForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isOpeningDateOfBirth = false;

  bool get _canContinue =>
      validateName(_firstNameController.text, isRequired: true) == null &&
      validateName(_lastNameController.text, isRequired: false) == null;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _continueWithNames() async {
    if (!_canContinue || _isOpeningDateOfBirth) return;

    // Keep the raw draft here and pass the trimmed names to the next step.
    FocusScope.of(context).unfocus();
    final lastName = _lastNameController.text.trim();
    // Hold one route push open until the user returns to this form.
    _isOpeningDateOfBirth = true;
    try {
      await widget.onContinue(
        _firstNameController.text.trim(),
        lastName.isEmpty ? null : lastName,
      );
    } finally {
      _isOpeningDateOfBirth = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.header,
            const SizedBox(height: 32),
            _RegistrationNameField(
              controller: _firstNameController,
              hintText: strings.registrationFirstName,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _RegistrationNameField(
              controller: _lastNameController,
              hintText: strings.registrationLastName,
              isRequired: false,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Keep button eligibility local to the two editable values.
              ListenableBuilder(
                listenable: Listenable.merge([
                  _firstNameController,
                  _lastNameController,
                ]),
                builder: (context, _) => PrimaryButton(
                  label: strings.authContinue,
                  onPressed: _canContinue ? _continueWithNames : null,
                ),
              ),
              const SizedBox(height: 32),
              const AppLegalNotice(),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegistrationNameField extends StatefulWidget {
  const _RegistrationNameField({
    required this.controller,
    required this.hintText,
    required this.isRequired,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isRequired;

  @override
  State<_RegistrationNameField> createState() => _RegistrationNameFieldState();
}

class _RegistrationNameFieldState extends State<_RegistrationNameField> {
  bool _hasBlurred = false;

  void _handleFocusChange(bool hasFocus) {
    // Give the user a chance to enter the required name before showing an error.
    if (!hasFocus && !_hasBlurred) {
      setState(() => _hasBlurred = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Focus(
      canRequestFocus: false,
      onFocusChange: _handleFocusChange,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (context, value, _) {
          final error = validateName(value.text, isRequired: widget.isRequired);
          final errorText = switch (error) {
            NameError.missing when _hasBlurred =>
              strings.registrationFirstNameRequired,
            NameError.invalidCharacters =>
              strings.registrationNameInvalidCharacters,
            NameError.tooLong => strings.registrationNameTooLong,
            _ => null,
          };

          return InputTextField(
            controller: widget.controller,
            hintText: widget.hintText,
            keyboardType: TextInputType.name,
            textAlign: TextAlign.start,
            errorText: errorText,
          );
        },
      ),
    );
  }
}
