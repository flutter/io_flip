import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/leaderboard/initials_form/initials_form.dart';

void main() {
  group('InitialsFormState', () {
    group('copyWith', () {
      test('does not update omitted params', () {
        const state = InitialsFormState(initials: ['A', 'B', 'C']);
        expect(state.copyWith(), equals(state));
      });
    });
  });
}
