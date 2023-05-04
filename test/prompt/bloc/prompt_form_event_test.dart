// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/prompt/prompt.dart';

void main() {
  group('PromptTermsRequested', () {
    test('can be instantiated', () {
      expect(PromptTermsRequested(), isNotNull);
    });

    test('supports equality', () {
      expect(
        PromptTermsRequested(),
        equals(PromptTermsRequested()),
      );
    });
  });
  group('PromptSubmitted', () {
    test('can be instantiated', () {
      expect(PromptSubmitted(data: Prompt()), isNotNull);
    });

    test('supports equality', () {
      expect(
        PromptSubmitted(data: Prompt()),
        equals(PromptSubmitted(data: Prompt())),
      );
    });
  });
}
