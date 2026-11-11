import 'package:donuts_code_test/core/domain/result.dart';

enum AuthFailure { invalidOtp }

abstract interface class AuthRepository {
  Future<Result<void, AuthFailure>> verifyOtp(String code);
}
