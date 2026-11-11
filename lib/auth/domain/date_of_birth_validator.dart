const minimumRegistrationAge = 13;

enum DateOfBirthError { invalidDate, futureDate, underage }

DateOfBirthError? validateDateOfBirth({
  required int year,
  required int month,
  required int day,
  required DateTime today,
}) {
  if (year < 1 || month < 1 || month > 12 || day < 1) {
    return DateOfBirthError.invalidDate;
  }
  if (day > _daysInMonth(year, month)) {
    return DateOfBirthError.invalidDate;
  }

  final yearsSinceBirth = today.year - year;
  final birthdayIsAhead =
      month > today.month || (month == today.month && day > today.day);

  if (yearsSinceBirth < 0 || (yearsSinceBirth == 0 && birthdayIsAhead)) {
    return DateOfBirthError.futureDate;
  }

  final age = birthdayIsAhead ? yearsSinceBirth - 1 : yearsSinceBirth;
  return age < minimumRegistrationAge ? DateOfBirthError.underage : null;
}

int _daysInMonth(int year, int month) {
  if (month == 2) {
    final isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }
  return switch (month) {
    4 || 6 || 9 || 11 => 30,
    _ => 31,
  };
}