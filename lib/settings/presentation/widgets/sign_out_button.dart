import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/auth_providers.dart';
import '../../../core/domain/result.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';

class SignOutButton extends ConsumerStatefulWidget {
  const SignOutButton({super.key});

  @override
  ConsumerState<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends ConsumerState<SignOutButton> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final strings = AppLocalizations.of(context)!;
    setState(() => _isSigningOut = true);
    final result = await ref.read(authRepositoryProvider).logOut();
    if (!messenger.mounted) return;

    if (result is Success) {
      // Replace the protected route even if the footer scrolled offscreen.
      router.go('/');
      return;
    }

    if (mounted) setState(() => _isSigningOut = false);
    messenger.showSnackBar(SnackBar(content: Text(strings.signOutFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return PrimaryButton(
      label: strings.signOut,
      loadingLabel: _isSigningOut ? strings.signingOut : null,
      onPressed: _signOut,
    );
  }
}
