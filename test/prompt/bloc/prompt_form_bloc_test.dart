// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/prompt/prompt.dart';

class _MockPromptResource extends Mock implements PromptResource {}

void main() {
  setUpAll(() {
    registerFallbackValue(PromptTermType.characterClass);
  });

  group('PromptFormBloc', () {
    late PromptResource promptResource;
    const data = Prompt(
      characterClass: 'character',
      power: 'power',
    );
    setUp(() {
      promptResource = _MockPromptResource();
    });

    blocTest<PromptFormBloc, PromptFormState>(
      'emits state with prompts',
      setUp: () {
        when(() => promptResource.getPromptTerms(any()))
            .thenAnswer((_) async => ['test']);
      },
      build: () => PromptFormBloc(promptResource: promptResource),
      seed: () => PromptFormState(
        status: PromptTermsStatus.loaded,
        prompts: Prompt(),
      ),
      act: (bloc) {
        bloc.add(PromptSubmitted(data: data));
      },
      expect: () => <PromptFormState>[
        PromptFormState(
          status: PromptTermsStatus.loaded,
          prompts: data,
        ),
      ],
    );

    blocTest<PromptFormBloc, PromptFormState>(
      'emits state with error status',
      setUp: () {
        when(() => promptResource.getPromptTerms(any()))
            .thenThrow(Exception('Oops'));
      },
      build: () => PromptFormBloc(promptResource: promptResource),
      act: (bloc) {
        bloc.add(PromptTermsRequested());
      },
      expect: () => <PromptFormState>[
        PromptFormState(
          status: PromptTermsStatus.loading,
          prompts: Prompt(),
        ),
        PromptFormState(
          status: PromptTermsStatus.failed,
          prompts: Prompt(),
        ),
      ],
    );
  });
}
