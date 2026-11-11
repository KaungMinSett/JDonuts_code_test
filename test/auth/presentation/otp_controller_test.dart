import 'dart:async';

import 'package:donuts_code_test/auth/auth_providers.dart';
import 'package:donuts_code_test/auth/data/fake_auth_repository.dart';
import 'package:donuts_code_test/auth/domain/auth_repository.dart';
import 'package:donuts_code_test/auth/presentation/otp_controller.dart';
import 'package:donuts_code_test/core/domain/result.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('locks after three wrong codes until the user resends', () {
    fakeAsync((time) {
      final container = _startOtp(time);
      final controller = container.read(otpControllerProvider.notifier);
      expect(container.read(otpControllerProvider).resendSecondsRemaining, 300);

      for (var attempt = 0; attempt < 2; attempt++) {
        unawaited(controller.verify('654321'));
        time.elapse(Duration.zero);
        expect(
          container.read(otpControllerProvider).status,
          OtpStatus.invalidCode,
        );
      }

      unawaited(controller.verify('654321'));
      time.elapse(Duration.zero);
      expect(container.read(otpControllerProvider).status, OtpStatus.locked);

      unawaited(controller.verify('123456'));
      time.elapse(Duration.zero);
      expect(container.read(otpControllerProvider).status, OtpStatus.locked);

      time.elapse(const Duration(minutes: 4, seconds: 59));
      controller.resend();
      final beforeDeadline = container.read(otpControllerProvider);
      expect(beforeDeadline.status, OtpStatus.locked);
      expect(beforeDeadline.resendSecondsRemaining, 1);
      expect(beforeDeadline.canResend, isFalse);

      time.elapse(const Duration(seconds: 1));
      final expired = container.read(otpControllerProvider);
      expect(expired.status, OtpStatus.locked);
      expect(expired.resendSecondsRemaining, 0);
      expect(expired.canResend, isTrue);

      controller.resend();
      final resent = container.read(otpControllerProvider);
      expect(resent.canEnterCode, isTrue);
      expect(resent.resendSecondsRemaining, 300);
      expect(resent.canResend, isFalse);

      unawaited(controller.verify('654321'));
      time.elapse(Duration.zero);
      expect(
        container.read(otpControllerProvider).status,
        OtpStatus.invalidCode,
      );
    });
  });

  test('shows loading and sends one request for duplicate submissions', () {
    fakeAsync((time) {
      final repository = _PendingAuthRepository();
      final container = _startOtp(time, repository: repository);
      final controller = container.read(otpControllerProvider.notifier);

      unawaited(controller.verify('123456'));
      unawaited(controller.verify('123456'));
      expect(repository.calls, 1);
      expect(container.read(otpControllerProvider).status, OtpStatus.verifying);

      repository.result.complete(const Success<void, AuthFailure>(null));
      time.flushMicrotasks();
      expect(container.read(otpControllerProvider).status, OtpStatus.verified);
    });
  });
}

ProviderContainer _startOtp(
  FakeAsync time, {
  AuthRepository repository = const FakeAuthRepository(delay: Duration.zero),
}) {
  final container = ProviderContainer.test(
    overrides: [
      authRepositoryProvider.overrideWithValue(repository),
      otpControllerProvider.overrideWith(
        () => OtpController(now: time.getClock(DateTime(2026, 11, 11)).now),
      ),
    ],
  );
  container.listen(otpControllerProvider, (_, _) {});
  return container;
}

final class _PendingAuthRepository implements AuthRepository {
  final result = Completer<Result<void, AuthFailure>>();
  int calls = 0;

  @override
  Future<Result<void, AuthFailure>> verifyOtp(String code) {
    calls++;
    return result.future;
  }
}
