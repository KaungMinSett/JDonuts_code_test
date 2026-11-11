import 'package:donuts_code_test/auth/data/fake_auth_repository.dart';
import 'package:donuts_code_test/auth/domain/auth_repository.dart';
import 'package:donuts_code_test/core/domain/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AuthRepository repository = FakeAuthRepository(delay: Duration.zero);

  test('accepts the configured fake OTP', () async {
    final result = await repository.verifyOtp('123456');

    expect(result, isA<Success<void, OtpFailure>>());
  });

  test('rejects a different six-digit OTP with a typed failure', () async {
    final result = await repository.verifyOtp('654321');

    expect(
      result,
      isA<Failure<void, OtpFailure>>().having(
        (failure) => failure.error,
        'error',
        OtpFailure.invalidCode,
      ),
    );
  });

  group('Local accounts and sessions', () {
    const registeredPhone = '+959254135592';

    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('reports an unregistered number at the phone step', () async {
      final result = await repository.checkRegisteredPhone(registeredPhone);

      expect(
        result,
        isA<Failure<void, AuthFailure>>().having(
          (failure) => failure.error,
          'error',
          AuthFailure.accountNotFound,
        ),
      );
    });

    test(
      'keeps the registered account after logout and restores a new session',
      () async {
        final registration = await repository.register(
          normalizedPhone: registeredPhone,
          firstName: 'May',
          dateOfBirth: DateTime(2000, 1, 1),
        );
        expect(registration, isA<Success<String, AuthFailure>>());
        expect(
          await repository.restoreSession(),
          isA<Success<String?, AuthFailure>>().having(
            (session) => session.value,
            'active phone',
            registeredPhone,
          ),
        );

        expect(await repository.logOut(), isA<Success<void, AuthFailure>>());
        expect(
          await repository.checkRegisteredPhone(registeredPhone),
          isA<Success<void, AuthFailure>>(),
        );

        // Checking the account only opens OTP. The user is still signed out.
        expect(
          await repository.restoreSession(),
          isA<Success<String?, AuthFailure>>().having(
            (session) => session.value,
            'active phone',
            isNull,
          ),
        );

        expect(
          await repository.verifyOtp('123456'),
          isA<Success<void, OtpFailure>>(),
        );
        expect(
          await repository.startSessionForVerifiedPhone(registeredPhone),
          isA<Success<String, AuthFailure>>(),
        );
        expect(
          await repository.restoreSession(),
          isA<Success<String?, AuthFailure>>().having(
            (session) => session.value,
            'active phone',
            registeredPhone,
          ),
        );
      },
    );
  });
}
