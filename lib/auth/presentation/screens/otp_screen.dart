import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/app_legal_notice.dart';
import '../widgets/auth_step_layout.dart';
import '../widgets/otp_verification_form.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    required this.normalizedPhone,
    required this.isLogin,
    super.key,
  });

  final String normalizedPhone;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return AuthStepLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthStepHeader(
                title: strings.otpTitle,
                progress: isLogin ? 1 : 0.5,
              ),
              const SizedBox(height: 12),
              Text(
                strings.otpSentTo(normalizedPhone),

              ),
              const SizedBox(height: 32),
              OtpVerificationForm(
                normalizedPhone: normalizedPhone,
                isLogin: isLogin,
              ),
            ],
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
