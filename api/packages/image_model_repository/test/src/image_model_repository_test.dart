// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:game_domain/game_domain.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:test/test.dart';

class _MockPromptRepository extends Mock implements PromptRepository {}

class _MockRandom extends Mock implements Random {}

void main() {
  group('ImageModelRepository', () {
    late ImageModelRepository repository;
    late PromptRepository promptRepository;
    late Random random;

    setUp(() {
      promptRepository = _MockPromptRepository();
      random = _MockRandom();
      when(() => random.nextInt(any())).thenReturn(0);
      repository = ImageModelRepository(
        promptRepository: promptRepository,
        imageHost: 'https://my_host.com/',
        rng: random,
      );
    });

    test('can be instantiated', () {
      expect(
        ImageModelRepository(
          promptRepository: _MockPromptRepository(),
          imageHost: 'https://my_host.com/',
        ),
        isNotNull,
      );
    });

    test('returns complete set of cards', () async {
      when(
        () => promptRepository.getPromptTermsByType(PromptTermType.character),
      ).thenAnswer(
        (_) async => [
          PromptTerm(
            type: PromptTermType.character,
            term: 'dash',
          ),
          PromptTerm(
            type: PromptTermType.character,
            term: 'sparky',
          ),
        ],
      );

      when(
        () => promptRepository.getPromptTermsByType(PromptTermType.location),
      ).thenAnswer(
        (_) async => [
          PromptTerm(
            type: PromptTermType.location,
            term: 'volcano',
          ),
          PromptTerm(
            type: PromptTermType.location,
            term: 'beach',
          ),
        ],
      );

      final paths = await repository.generateImages(
        characterClass: 'mage',
        variationsAvailable: 2,
        deckSize: 8,
      );

      expect(
        paths.map((e) => e.url),
        unorderedEquals([
          'https://my_host.com/dash_mage_volcano_0.png',
          'https://my_host.com/dash_mage_volcano_0.png',
          'https://my_host.com/dash_mage_volcano_0.png',
          'https://my_host.com/dash_mage_volcano_0.png',
          'https://my_host.com/sparky_mage_volcano_0.png',
          'https://my_host.com/sparky_mage_volcano_0.png',
          'https://my_host.com/sparky_mage_volcano_0.png',
          'https://my_host.com/sparky_mage_volcano_0.png',
        ]),
      );
      expect(
        paths.map((e) => e.character),
        unorderedEquals([
          'dash',
          'dash',
          'dash',
          'dash',
          'sparky',
          'sparky',
          'sparky',
          'sparky',
        ]),
      );
      expect(
        paths.map((e) => e.characterClass),
        unorderedEquals([
          'mage',
          'mage',
          'mage',
          'mage',
          'mage',
          'mage',
          'mage',
          'mage',
        ]),
      );
      expect(
        paths.map((e) => e.location),
        unorderedEquals([
          'volcano',
          'volcano',
          'volcano',
          'volcano',
          'volcano',
          'volcano',
          'volcano',
          'volcano',
        ]),
      );
    });
  });
}
