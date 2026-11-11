import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_motion.dart';
import '../../../core/domain/result.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth_providers.dart';
import '../../domain/otp_validator.dart';
import '../otp_controller.dart';
import 'otp_code_input.dart';
import 'otp_error_shake.dart';
import 'otp_resend.dart';

class OtpVerificationForm extends ConsumerStatefulWidget {
  const OtpVerificationForm({
    required this.normalizedPhone,
    required this.isLogin,
    super.key,
  });

  final String normalizedPhone;
  final bool isLogin;

  @override
  ConsumerState<OtpVerificationForm> createState() =>
      _OtpVerificationFormState();
}

class _OtpVerificationFormState extends ConsumerState<OtpVerificationForm> {
  final _codeController = TextEditingController();
  final _codeFocus = FocusNode();
  bool _isSavingSession = false;
  bool _sessionSaveFailed = false;

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _verifyCompleteCode(String code) {
    // Typing the last digit, pasting, and SMS autofill use the same path.
    if (isValidOtpFormat(code)) {
      ref.read(otpControllerProvider.notifier).verify(code);
    }
  }

  void _handleOtpStatus(OtpStatus status) {
    if (!mounted || ModalRoute.isCurrentOf(context) != true) return;

    switch (status) {
      case OtpStatus.invalidCode:
      case OtpStatus.locked:
        // Clear the rejected code while preserving the controller's attempt count.
        _codeController.clear();
        if (status == OtpStatus.locked) _codeFocus.unfocus();
      case OtpStatus.verified:
        _codeFocus.unfocus();
        _continueAfterVerification();
      case OtpStatus.ready:
      case OtpStatus.verifying:
        break;
    }
  }

  void _resendCode() {
    if (!ref.read(otpControllerProvider).canResend) return;
    ref.read(otpControllerProvider.notifier).resend();
    _codeController.clear();

    // A locked field must rebuild as enabled before it can take focus again.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ModalRoute.isCurrentOf(context) == true) {
        _codeFocus.requestFocus();
      }
    });
  }

  Future<void> _continueAfterVerification() async {
    if (_isSavingSession || ModalRoute.isCurrentOf(context) != true) return;

    if (widget.isLogin) {
      await _saveLoginSession();
    } else {
      // Keep this route and the verified code on the stack for Back from Name.
      context.push<void>(
        '/phone/name',
        extra: {'normalizedPhone': widget.normalizedPhone},
      );
    }
  }

  Future<void> _saveLoginSession() async {
    setState(() {
      _isSavingSession = true;
      _sessionSaveFailed = false;
    });

    try {
      // Persist the verified login before opening Home.
      final result = await ref
          .read(authRepositoryProvider)
          .startSessionForVerifiedPhone(widget.normalizedPhone);
      if (!mounted) return;

      switch (result) {
        case Success():
          if (ModalRoute.isCurrentOf(context) == true) context.go('/home');
        case Failure():
          setState(() => _sessionSaveFailed = true);
      }
    } finally {
      if (mounted) setState(() => _isSavingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Resend owns the countdown subscription so ticking does not rebuild input.
    final status = ref.watch(
      otpControllerProvider.select((state) => state.status),
    );
    final wrongAttempts = ref.watch(
      otpControllerProvider.select((state) => state.wrongAttempts),
    );
    ref.listen(
      otpControllerProvider.select((state) => state.status),
      (_, status) => _handleOtpStatus(status),
    );

    final strings = AppLocalizations.of(context)!;

    return PopScope<void>(
      // Complete the secure-storage write before leaving the verified login.
      canPop: !_isSavingSession,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpErrorShake(
            wrongAttempts: wrongAttempts,
            child: OtpCodeInput(
              controller: _codeController,
              focusNode: _codeFocus,
              onChanged: _verifyCompleteCode,
              enabled:
                  status != OtpStatus.locked && status != OtpStatus.verified,
              readOnly: status == OtpStatus.verifying,
              hasError:
                  status == OtpStatus.invalidCode || status == OtpStatus.locked,
            ),
          ),
          const SizedBox(height: 16),
          _OtpFeedback(status: status, sessionSaveFailed: _sessionSaveFailed),
          if (status == OtpStatus.verified)
            PrimaryButton(
              label: strings.authContinue,
              loadingLabel: _isSavingSession ? strings.otpSigningIn : null,
              onPressed: _continueAfterVerification,
            )
          else
            OtpResend(onResend: _resendCode),
        ],
      ),
    );
  }
}

class _OtpFeedback extends StatelessWidget {
  const _OtpFeedback({required this.status, required this.sessionSaveFailed});

  final OtpStatus status;
  final bool sessionSaveFailed;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final message = switch (status) {
      OtpStatus.verifying => strings.otpVerifying,
      OtpStatus.invalidCode => strings.otpInvalidCode,
      OtpStatus.locked => strings.otpTooManyAttempts,
      OtpStatus.verified when sessionSaveFailed => strings.otpSessionSaveFailed,
      _ => null,
    };

    return AnimatedSwitcher(
      duration: reduceMotion ? Duration.zero : AppMotion.otpFeedbackDuration,
      switchInCurve: AppMotion.otpFeedbackCurve,
      switchOutCurve: AppMotion.otpFeedbackCurve,
      child: message == null
          ? const SizedBox.shrink()
          : Padding(
              key: ValueKey(message),
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: status == OtpStatus.verifying
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.error,
                  ),
                ),
              ),
            ),
    );
  }
}
