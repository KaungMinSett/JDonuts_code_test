import 'package:flutter/material.dart';

import '../../../app/config/app_media.dart';
import '../../../l10n/app_localizations.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      children: [
        _SocialLoginButton(
          label: strings.signInWithGoogle,
          assetPath: AppMedia.googleLogo,
          fallback: Icons.g_mobiledata,
          onPressed: onPressed,
        ),
        _SocialLoginButton(
          label: strings.signInWithApple,
          assetPath: AppMedia.appleLogo,
          fallback: Icons.apple,
          onPressed: onPressed,
        ),
        _SocialLoginButton(
          label: strings.signInWithFacebook,
          assetPath: AppMedia.facebookLogo,
          fallback: Icons.facebook,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.assetPath,
    required this.fallback,
    required this.onPressed,
  });

  static const _logoSize = 24.0;

  final String label;
  final String assetPath;
  final IconData fallback;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: SizedBox.square(
        dimension: _logoSize,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
          errorBuilder: (_, _, _) => Icon(fallback, size: _logoSize),
        ),
      ),
    );
  }
}
