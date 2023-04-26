import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

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
