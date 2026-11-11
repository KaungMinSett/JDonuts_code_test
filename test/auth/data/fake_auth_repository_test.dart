import 'package:donuts_code_test/auth/data/fake_auth_repository.dart';
import 'package:donuts_code_test/auth/domain/auth_repository.dart';
import 'package:donuts_code_test/core/domain/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AuthRepository repository = FakeAuthRepository(delay: Duration.zero);

  test('accepts the configured fake OTP', () async {
    final result = await repository.verifyOtp('123456');

    expect(result, isA<Success<void, AuthFailure>>());
  });

  test('rejects a different six-digit OTP with a typed failure', () async {
    final result = await repository.verifyOtp('654321');

    expect(
      result,
      isA<Failure<void, AuthFailure>>()
          .having((failure) => failure.error, 'error', AuthFailure.invalidOtp),
    );
  });
}
