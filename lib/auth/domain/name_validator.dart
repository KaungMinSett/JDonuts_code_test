import 'package:characters/characters.dart';

const _maxNameLength = 50;
final _lettersAndSpaces = RegExp(r'^(?:\p{L}\p{M}*| )+$', unicode: true);

enum NameError { missing, tooLong, invalidCharacters }

NameError? validateName(String input, {required bool isRequired}) {
  final name = input.trim();

  if (name.isEmpty) {
    return isRequired ? NameError.missing : null;
  }
  if (!_lettersAndSpaces.hasMatch(name)) {
    return NameError.invalidCharacters;
  }
  if (name.characters.length > _maxNameLength) {
    return NameError.tooLong;
  }
  return null;
}