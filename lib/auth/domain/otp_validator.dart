const otpCodeLength = 6;
final _digitsOnly = RegExp(r'^[0-9]+$');

bool isValidOtpFormat(String input) {
  return input.length == otpCodeLength && _digitsOnly.hasMatch(input);
}
