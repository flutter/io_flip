import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/prompt/bloc/prompt_form_bloc.dart';

void main() {
  group('PromptFormState', () {
    group('copyWith', () {
      test('does not update omitted params', () {
        const state = PromptFormState.initial();
        expect(state.copyWith(), equals(state));
      });
    });
  });
}
