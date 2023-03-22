import 'package:formz/formz.dart';
import 'package:top_dash/l10n/l10n.dart';

enum InitialsValidationError { invalid }

extension InitialsValidationErrorX on InitialsValidationError {
  String text(AppLocalizations l10n) {
    switch (this) {
      case InitialsValidationError.invalid:
        return l10n.enterInitialsError;
    }
  }
}

class Initials extends FormzInput<String?, InitialsValidationError> {
  Initials.pure([super.value = '']) : super.pure();
  Initials.dirty([super.value = '']) : super.dirty();

  final initialsRegex = RegExp('[A-Z]{3}');
  static const initialsBlacklist = [
    'FUK',
    'FUC',
    'COK',
    'DIK',
    'KKK',
    'SHT',
    'CNT',
    'ASS',
    'CUM',
    'FAG',
    'GAY',
    'GOD',
    'JEW',
    'SEX',
    'TIT',
    'WTF',
  ];

  @override
  InitialsValidationError? validator(String? value) {
    if (value == null ||
        value.isEmpty ||
        !initialsRegex.hasMatch(value) ||
        initialsBlacklist.contains(value)) {
      return InitialsValidationError.invalid;
    }
    return null;
  }
}
