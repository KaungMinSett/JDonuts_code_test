const _otpLength = 6;
final _digitsOnly = RegExp(r'^[0-9]+$');

bool isValidOtpFormat(String input) {
  return input.length == _otpLength && _digitsOnly.hasMatch(input);
}