import 'package:donuts_code_test/core/domain/result.dart';

enum OtpFailure { invalidCode }

enum AuthFailure { accountNotFound, storageUnavailable }

abstract interface class AuthRepository {
  Future<Result<void, OtpFailure>> verifyOtp(String code);

  Future<Result<String, AuthFailure>> register({
    required String normalizedPhone,
    required String firstName,
    required DateTime dateOfBirth,
    String? lastName,
  });

  Future<Result<void, AuthFailure>> checkRegisteredPhone(
    String normalizedPhone,
  );

  /// Call after the login flow checks the registered phone and verifies its OTP.
  Future<Result<String, AuthFailure>> startSessionForVerifiedPhone(
    String normalizedPhone,
  );

  Future<Result<String?, AuthFailure>> restoreSession();

  Future<Result<void, AuthFailure>> logOut();
}
