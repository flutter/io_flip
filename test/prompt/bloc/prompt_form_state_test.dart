import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/prompt/bloc/prompt_form_bloc.dart';

void main() {
  group('PromptFormState', () {
    group('copyWith', () {
      test('does not update omitted params', () {
        const state = PromptFormState();
        expect(state.copyWith(), equals(state));
      });
    });
  });
}
