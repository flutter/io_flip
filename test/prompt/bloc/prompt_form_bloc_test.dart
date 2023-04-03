// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/prompt/prompt.dart';

class _MockPromptResource extends Mock implements PromptResource {}

void main() {
  group('PromptFormBloc', () {
    late PromptResource promptResource;
    const data = FlowData(
      character: 'character',
      power: 'power',
      environment: 'environment',
    );
    setUp(() {
      promptResource = _MockPromptResource();

      when(() => promptResource.getPromptWhitelist())
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
