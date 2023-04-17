// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/prompt/prompt.dart';

class _MockPromptResource extends Mock implements PromptResource {}

void main() {
  group('PromptFormBloc', () {
    late PromptResource promptResource;
    const data = Prompt(
      characterClass: 'character',
      power: 'power',
      secondaryPower: 'environment',
    );
    setUp(() {
      promptResource = _MockPromptResource();

      when(() => promptResource.getPromptTerms(any()))
          .thenAnswer((_) async => ['test']);
    });

    blocTest<PromptFormBloc, PromptFormState>(
      'emits state with prompts',
      build: () => PromptFormBloc(promptResource: promptResource),
      act: (bloc) {
        bloc.add(PromptSubmitted(data: data));
      },
      expect: () => <PromptFormState>[
        PromptFormState(prompts: data),
      ],
    );
  });
}
