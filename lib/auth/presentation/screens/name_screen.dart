import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/app_legal_notice.dart';
import '../widgets/auth_step_layout.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({required this.normalizedPhone, super.key});

  final String normalizedPhone;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return AuthStepLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthStepHeader(title: strings.registrationNameTitle, progress: 0.75),
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: AppLegalNotice(),
          ),
        ],
      ),
    );
  }
}
