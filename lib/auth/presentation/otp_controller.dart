import 'dart:async';

import 'package:donuts_code_test/core/domain/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth_providers.dart';
import '../domain/auth_repository.dart';
import '../domain/otp_validator.dart';

const _resendDelay = Duration(minutes: 5);
const _maxWrongAttempts = 3;

enum OtpStatus { ready, verifying, invalidCode, locked, verified }

final class OtpState {
  const OtpState({
    required this.resendSecondsRemaining,
    this.status = OtpStatus.ready,
    this.wrongAttempts = 0,
  });

  final int resendSecondsRemaining;
  final OtpStatus status;
  final int wrongAttempts;

  bool get canEnterCode =>
      status == OtpStatus.ready || status == OtpStatus.invalidCode;

  bool get canResend =>
      resendSecondsRemaining == 0 &&
      (canEnterCode || status == OtpStatus.locked);

  OtpState _copyWith({
    int? resendSecondsRemaining,
    OtpStatus? status,
    int? wrongAttempts,
  }) {
    return OtpState(
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      status: status ?? this.status,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
    );
  }
}

final otpControllerProvider =
    NotifierProvider.autoDispose<OtpController, OtpState>(OtpController.new);

final class OtpController extends Notifier<OtpState> {
  OtpController({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  Timer? _timer;

  @override
  OtpState build() {
    ref.onDispose(() => _timer?.cancel());
    return _startCountdown();
  }

  Future<void> verify(String code) async {
    if (!state.canEnterCode || !isValidOtpFormat(code)) return;

    final lifecycle = ref;
    final repository = lifecycle.read(authRepositoryProvider);
    final previousStatus = state.status;
    state = state._copyWith(status: OtpStatus.verifying);
    try {
      final result = await repository.verifyOtp(code);
      if (lifecycle.mounted) _applyResult(result);
    } finally {
      if (lifecycle.mounted && state.status == OtpStatus.verifying) {
        state = state._copyWith(status: previousStatus);
      }
    }
  }

  void resend() {
    if (state.canResend) state = _startCountdown();
  }

  void _applyResult(Result<void, AuthFailure> result) {
    switch (result) {
      case Success():
        _timer?.cancel();
        state = state._copyWith(status: OtpStatus.verified);
      case Failure(error: AuthFailure.invalidOtp):
        final wrongAttempts = state.wrongAttempts + 1;
        state = state._copyWith(
          wrongAttempts: wrongAttempts,
          status: wrongAttempts >= _maxWrongAttempts
              ? OtpStatus.locked
              : OtpStatus.invalidCode,
        );
    }
  }

  OtpState _startCountdown() {
    _timer?.cancel();
    final deadline = _now().add(_resendDelay);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateCountdown(timer, deadline),
    );
    return OtpState(resendSecondsRemaining: _resendDelay.inSeconds);
  }

  void _updateCountdown(Timer timer, DateTime deadline) {
    final remaining = deadline.difference(_now()).inMicroseconds;
    const microsPerSecond = Duration.microsecondsPerSecond;
    final seconds = remaining <= 0
        ? 0
        : (remaining + microsPerSecond - 1) ~/ microsPerSecond;

    if (seconds == 0) timer.cancel();
    if (seconds != state.resendSecondsRemaining) {
      state = state._copyWith(resendSecondsRemaining: seconds);
    }
  }
}
