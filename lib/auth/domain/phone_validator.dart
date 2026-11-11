const _myanmarCountryCode = '+95';

final _phoneSeparators = RegExp(r'[\s-]');
final _mobileNumber = RegExp(r'^9[0-9]{7,9}$');

String? normalizeMyanmarPhone(String input) {
  var number = input.replaceAll(_phoneSeparators, '');
  //print('Normalized input: $number');
  if (number.startsWith('0')) {
    number = number.substring(1);
    //print('Removed leading 0: $number');
  }

  if (!_mobileNumber.hasMatch(number)) {
    return null;
  }
  return '$_myanmarCountryCode$number';
}