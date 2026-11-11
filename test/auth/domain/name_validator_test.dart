import 'package:donuts_code_test/auth/domain/name_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateName', () {
    test('requires a first name and allows a blank last name', () {
      expect(validateName('  ', isRequired: true), NameError.missing);
      expect(validateName('  ', isRequired: false), isNull);
    });

    test('accepts Myanmar letters, combining marks, and spaces', () {
      expect(validateName('  မောင် မောင်  ', isRequired: true), isNull);
    });

    test('accepts 1 and 50 characters after trimming, rejects 51', () {
      final fiftyCharacters = 'ကိ' * 50;

      expect(validateName(' A ', isRequired: true), isNull);
      expect(validateName(' $fiftyCharacters ', isRequired: true), isNull);
      expect(
        validateName('$fiftyCharactersကိ', isRequired: false),
        NameError.tooLong,
      );
    });

    test('rejects digits and punctuation, including in an optional name', () {
      expect(validateName('မောင်၁', isRequired: true), NameError.invalidCharacters);
      expect(validateName('A-B', isRequired: false), NameError.invalidCharacters);
    });
  });
}