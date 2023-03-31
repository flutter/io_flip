// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/prompt/bloc/prompt_form_bloc.dart';
import 'package:top_dash/prompt/prompt.dart';

void main() {
  group('PromptSubmitted', () {
    test('can be instantiated', () {
      expect(PromptSubmitted(data: FlowData()), isNotNull);
    });

    test('supports equality', () {
      expect(
        PromptSubmitted(data: FlowData()),
        equals(PromptSubmitted(data: FlowData())),
      );
    });
  });
}
