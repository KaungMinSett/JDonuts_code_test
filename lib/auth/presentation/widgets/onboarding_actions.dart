import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import 'app_legal_notice.dart';
import 'social_login_buttons.dart';

class OnboardingActions extends StatelessWidget {
  const OnboardingActions({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final accent = Theme.of(context).colorScheme.secondary;
    final loginStyle = textTheme.bodyLarge?.copyWith(
      color: accent,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: strings.onboardingGetStarted,
          onPressed: () => context.push<void>('/phone'),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(
              strings.onboardingAccountPrompt,
              style: textTheme.bodyMedium?.copyWith(letterSpacing: -0.5),
            ),
            AuthTextLink(
              label: strings.onboardingLogin,
              style: loginStyle,
              onPressed: () => context.push<void>('/phone?mode=login'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SocialLoginButtons(
          onPressed: () =>
              _showMessage(context, strings.socialSignInUnavailable),
        ),
        const SizedBox(height: 18),
        const AppLegalNotice(),
      ],
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
