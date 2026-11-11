import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/auth_step_layout.dart';
import '../widgets/date_of_birth_form.dart';

class DateOfBirthScreen extends StatelessWidget {
  const DateOfBirthScreen({
    required this.normalizedPhone,
    required this.firstName,
    required this.lastName,
    super.key,
  });

  final String normalizedPhone;
  final String firstName;
  final String? lastName;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return AuthStepLayout(
      child: DateOfBirthForm(
        normalizedPhone: normalizedPhone,
        firstName: firstName,
        lastName: lastName,
        header: AuthStepHeader(
          title: strings.registrationDateOfBirthTitle,
          progress: 1,
        ),
      ),
    );
  }
}
