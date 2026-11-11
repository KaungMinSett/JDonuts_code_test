import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../otp_controller.dart';
import 'app_legal_notice.dart';

class OtpResend extends ConsumerWidget {
  const OtpResend({required this.onResend, super.key});

  final VoidCallback onResend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (remaining, canResend) = ref.watch(
      otpControllerProvider.select(
        (state) => (state.resendSecondsRemaining, state.canResend),
      ),
    );
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final minutes = remaining ~/ Duration.secondsPerMinute;
    final seconds = (remaining % Duration.secondsPerMinute).toString().padLeft(
      2,
      '0',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.otpDidNotReceiveCode, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        // Use the controller's deadline and only enable Resend when it permits it.
        if (canResend)
          AuthTextLink(
            label: strings.otpResend,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
              decoration: TextDecoration.underline,
            ),
            onPressed: onResend,
          )
        else
          _ResendCountdown(time: '$minutes:$seconds'),
      ],
    );
  }
}

class _ResendCountdown extends StatelessWidget {
  const _ResendCountdown({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final label = strings.otpResendIn(time);
    final timeStart = label.indexOf(time);
    final style = theme.textTheme.bodyMedium;

    if (timeStart < 0) return Text(label, style: style);

    // Keep the localized word order and apply pink only to the time.
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label.substring(0, timeStart)),
          TextSpan(
            text: time,
            style: TextStyle(color: theme.colorScheme.secondary),
          ),
          TextSpan(text: label.substring(timeStart + time.length)),
        ],
      ),
      style: style,
    );
  }
}
