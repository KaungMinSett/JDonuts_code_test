import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/app_legal_notice.dart';
import '../widgets/auth_step_layout.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthStepHeader(
            title: strings.registrationDateOfBirthTitle,
            progress: 1,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: AppLegalNotice(),
          ),
        ],
      ),
    );
  }
}
