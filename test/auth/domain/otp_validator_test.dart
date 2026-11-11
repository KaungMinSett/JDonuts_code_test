import 'package:donuts_code_test/auth/domain/otp_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidOtpFormat', () {
    test('accepts exactly six digits, including a leading zero', () {
      expect(isValidOtpFormat('123456'), isTrue);
      expect(isValidOtpFormat('012345'), isTrue);
      expect(isValidOtpFormat('654321'), isTrue);
    });

    test('rejects empty input and codes with fewer or more than six digits', () {
      expect(isValidOtpFormat(''), isFalse);
      expect(isValidOtpFormat('12345'), isFalse);
      expect(isValidOtpFormat('1234567'), isFalse);
    });

    test('rejects letters, spaces, and pasted line breaks', () {
      expect(isValidOtpFormat('12345a'), isFalse);
      expect(isValidOtpFormat('123 56'), isFalse);
      expect(isValidOtpFormat('123456\n'), isFalse);
    });
  });
}