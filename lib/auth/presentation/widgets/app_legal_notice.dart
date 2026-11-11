import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AppLegalNotice extends StatelessWidget {
  const AppLegalNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      letterSpacing: -0.5,
    );
    final linkStyle = style?.copyWith(color: theme.colorScheme.secondary);
    void showLegalPlaceholder() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(strings.legalContentUnavailable)));

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: strings.onboardingLegalIntro),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: AuthTextLink(
              label: strings.onboardingTerms,
              style: linkStyle,
              onPressed: showLegalPlaceholder,
            ),
          ),
          TextSpan(text: strings.onboardingLegalSeparator),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: AuthTextLink(
              label: strings.onboardingPrivacy,
              style: linkStyle,
              onPressed: showLegalPlaceholder,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      style: style,
      textAlign: TextAlign.center,
    );
  }
}

class AuthTextLink extends StatelessWidget {
  const AuthTextLink({
    required this.label,
    required this.style,
    required this.onPressed,
    super.key,
  });

  final String label;
  final TextStyle? style;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: InkWell(
        onTap: onPressed,
        child: Text(label, style: style),
      ),
    );
  }
}
