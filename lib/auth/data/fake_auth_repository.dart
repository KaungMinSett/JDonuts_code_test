import 'package:donuts_code_test/core/domain/result.dart';

import '../domain/auth_repository.dart';

final class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository({this.delay = const Duration(seconds: 1)}); // for testing purposes

  static const _fakeOtp = '123456';

  final Duration delay;

  @override
  Future<Result<void, AuthFailure>> verifyOtp(String code) async {
    await Future<void>.delayed(delay);

    if (code == _fakeOtp) {
      return const Success<void, AuthFailure>(null);
    }
    return const Failure<void, AuthFailure>(AuthFailure.invalidOtp);
  }
}
