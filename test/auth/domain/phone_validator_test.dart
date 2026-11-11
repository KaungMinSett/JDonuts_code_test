import 'package:donuts_code_test/auth/domain/phone_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeMyanmarPhone', () {
    test('strips spaces, dashes, and one leading zero', () {
      expect(normalizeMyanmarPhone(' 09 254-135-592 '), '+959254135592');
    });

    test('accepts seven to nine digits after the initial 9', () {
      expect(normalizeMyanmarPhone('91234567'), '+9591234567');
      expect(normalizeMyanmarPhone('912345678'), '+95912345678');
      expect(normalizeMyanmarPhone('9123456789'), '+959123456789');
    });

    test('rejects numbers below or above the allowed length', () {
      expect(normalizeMyanmarPhone('9123456'), isNull);
      expect(normalizeMyanmarPhone('91234567890'), isNull);
    });

    test('rejects a number that starts with a digit other than 9', () {
      expect(normalizeMyanmarPhone('81234567'), isNull);
    });

    test('rejects a second leading zero', () {
      expect(normalizeMyanmarPhone('0091234567'), isNull);
    });

    test('rejects letters and blank input', () {
      expect(normalizeMyanmarPhone('9123456a'), isNull);
      expect(normalizeMyanmarPhone('   '), isNull);
    });
  });
}