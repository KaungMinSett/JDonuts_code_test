import 'package:donuts_code_test/auth/domain/date_of_birth_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateDateOfBirth', () {
    final today = DateTime(2026, 11, 11);

    DateOfBirthError? validate(int year, int month, int day) {
      return validateDateOfBirth(
        year: year,
        month: month,
        day: day,
        today: today,
      );
    }

    test('rejects a day outside the month', () {
      expect(validate(2010, 4, 31), DateOfBirthError.invalidDate);
    });

    test('accepts February 29 only in leap years', () {
      expect(validate(2012, 2, 29), isNull);
      expect(validate(2011, 2, 29), DateOfBirthError.invalidDate);
    });

    test('rejects a future birth date', () {
      expect(validate(2026, 11, 12), DateOfBirthError.futureDate);
    });

    test('accepts someone on their 13th birthday', () {
      expect(validate(2013, 11, 11), isNull);
    });

    test('rejects someone one day short of turning 13', () {
      expect(validate(2013, 11, 12), DateOfBirthError.underage);
    });
  });
}