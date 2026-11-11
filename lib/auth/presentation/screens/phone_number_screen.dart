import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/auth_step_layout.dart';
import '../widgets/phone_number_form.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({
    required this.isLogin,
    this.initialPhone = '',
    super.key,
  });

  final bool isLogin;
  final String initialPhone;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return AuthStepLayout(
      child: PhoneNumberForm(
        isLogin: isLogin,
        initialPhone: initialPhone,
        header: AuthStepHeader(
          title: isLogin
              ? strings.loginPhoneNumberTitle
              : strings.phoneNumberTitle,
          progress: isLogin ? 0.5 : 0.25,
        ),
      ),
    );
  }
}
