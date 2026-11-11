import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/auth_step_layout.dart';
import '../widgets/registration_name_form.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({required this.normalizedPhone, super.key});

  final String normalizedPhone;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return AuthStepLayout(
      child: RegistrationNameForm(
        header: AuthStepHeader(
          title: strings.registrationNameTitle,
          progress: 0.75,
        ),
        // Push keeps this form's controllers alive when the user goes Back.
        onContinue: (firstName, lastName) async {
          await context.push<void>(
            '/phone/date-of-birth',
            extra: {
              'normalizedPhone': normalizedPhone,
              'firstName': firstName,
              'lastName': lastName,
            },
          );
        },
      ),
    );
  }
}
