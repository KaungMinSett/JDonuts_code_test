import 'dart:convert';

import 'package:donuts_code_test/core/domain/result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/auth_repository.dart';

base class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository({
    this._storage = const FlutterSecureStorage(),
    this.delay = const Duration(seconds: 1),
  });

  static const _fakeOtp = '123456';
  static const _accountsKey = 'auth.accounts';
  static const _activePhoneKey = 'auth.active_phone';

  final FlutterSecureStorage _storage;
  final Duration delay;

  @override
  Future<Result<void, OtpFailure>> verifyOtp(String code) async {
    await Future<void>.delayed(delay);

    if (code == _fakeOtp) {
      return const Success<void, OtpFailure>(null);
    }
    return const Failure<void, OtpFailure>(OtpFailure.invalidCode);
  }

  @override
  Future<Result<String, AuthFailure>> register({
    required String normalizedPhone,
    required String firstName,
    required DateTime dateOfBirth,
    String? lastName,
  }) async {
    await Future<void>.delayed(delay);

    return _runStorageOperation<String>(() async {
      final accounts = await _readRegisteredAccounts();

      // Save the account before marking the phone as signed in.
      accounts[normalizedPhone] = {
        'firstName': firstName,
        'lastName': lastName,
      };
      await _storage.write(key: _accountsKey, value: jsonEncode(accounts));
      await _storage.write(key: _activePhoneKey, value: normalizedPhone);

      return Success<String, AuthFailure>(normalizedPhone);
    });
  }

  @override
  Future<Result<void, AuthFailure>> checkRegisteredPhone(
    String normalizedPhone,
  ) async {
    await Future<void>.delayed(delay);

    return _runStorageOperation<void>(() async {
      final accounts = await _readRegisteredAccounts();

      // Reject unknown numbers before opening the OTP screen.
      if (!accounts.containsKey(normalizedPhone)) {
        return const Failure<void, AuthFailure>(AuthFailure.accountNotFound);
      }
      return const Success<void, AuthFailure>(null);
    });
  }

  @override
  Future<Result<String, AuthFailure>> startSessionForVerifiedPhone(
    String normalizedPhone,
  ) {
    return _runStorageOperation<String>(() async {
      await _storage.write(key: _activePhoneKey, value: normalizedPhone);
      return Success<String, AuthFailure>(normalizedPhone);
    });
  }

  @override
  Future<Result<String?, AuthFailure>> restoreSession() {
    return _runStorageOperation<String?>(() async {
      final activePhone = await _storage.read(key: _activePhoneKey);
      return Success<String?, AuthFailure>(activePhone);
    });
  }

  @override
  Future<Result<void, AuthFailure>> logOut() {
    return _runStorageOperation<void>(() async {
      // Clear the session while preserving all registered accounts.
      await _storage.delete(key: _activePhoneKey);
      return const Success<void, AuthFailure>(null);
    });
  }

  Future<Map<String, Object?>> _readRegisteredAccounts() async {
    final accountsJson = await _storage.read(key: _accountsKey);
    return accountsJson == null
        ? <String, Object?>{}
        : jsonDecode(accountsJson) as Map<String, Object?>;
  }

  Future<Result<T, AuthFailure>> _runStorageOperation<T>(
    Future<Result<T, AuthFailure>> Function() operation,
  ) async {
    try {
      return await operation();
    } on PlatformException {
      return Failure<T, AuthFailure>(AuthFailure.storageUnavailable);
    }
  }
}