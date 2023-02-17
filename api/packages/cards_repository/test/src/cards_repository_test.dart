// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cards_repository/cards_repository.dart';
import 'package:game_domain/game_domain.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCardRng extends Mock implements CardRng {}

class _MockImageModelRepository extends Mock implements ImageModelRepository {}

class _MockLanguageModelRepository extends Mock
    implements LanguageModelRepository {}

class _MockRandom extends Mock implements Random {}

void main() {
  group('CardsRepository', () {
    late CardRng cardRng;
    late ImageModelRepository imageModelRepository;
    late LanguageModelRepository languageModelRepository;
    late CardsRepository cardsRepository;

    setUp(() {
      cardRng = _MockCardRng();
      when(cardRng.rollRarity).thenReturn(false);
      when(
        () => cardRng.rollAttribute(
          base: any(named: 'base'),
          modifier: any(named: 'modifier'),
        ),
      ).thenReturn(10);
      imageModelRepository = _MockImageModelRepository();
      when(imageModelRepository.generateImage)
          .thenAnswer((_) async => 'https://image.png');

      languageModelRepository = _MockLanguageModelRepository();
      when(languageModelRepository.generateCardName)
          .thenAnswer((_) async => 'Super Bird');
      when(languageModelRepository.generateFlavorText)
          .thenAnswer((_) async => 'Super Bird Is Ready!');

      cardsRepository = CardsRepository(
        imageModelRepository: imageModelRepository,
        languageModelRepository: languageModelRepository,
        rng: cardRng,
      );
    });

    test('can be instantiated', () {
      expect(
        CardsRepository(
          imageModelRepository: const ImageModelRepository(),
          languageModelRepository: const LanguageModelRepository(),
        ),
        isNotNull,
      );
    });

    test('generates a common card', () async {
      final card = await cardsRepository.generateCard();

      expect(
        card,
        Card(
          id: '',
          name: 'Super Bird',
          description: 'Super Bird Is Ready!',
          image: 'https://image.png',
          rarity: false,
          design: 10,
          product: 10,
          frontend: 10,
          backend: 10,
        ),
      );
    });

    test('generates a rare card', () async {
      when(cardRng.rollRarity).thenReturn(true);
      final card = await cardsRepository.generateCard();

      expect(
        card,
        Card(
          id: '',
          name: 'Super Bird',
          description: 'Super Bird Is Ready!',
          image: 'https://image.png',
          rarity: true,
          design: 10,
          product: 10,
          frontend: 10,
          backend: 10,
        ),
      );

      verify(() => cardRng.rollAttribute(base: 10, modifier: 10)).called(4);
    });
  });

  group('CardRng', () {
    late Random rng;
    late CardRng cardRng;

    setUp(() {
      rng = _MockRandom();
      cardRng = CardRng(rng: rng);
    });

    test('can be instantiated', () {
      expect(CardRng(), isNotNull);
    });

    test('rollRarity returns true when less than the chance threshold', () {
      when(rng.nextDouble).thenReturn(CardRng.rareChance - .1);
      expect(cardRng.rollRarity(), isTrue);
    });

    test('rollRarity returns false when greater than the chance threshold', () {
      when(rng.nextDouble).thenReturn(CardRng.rareChance + .1);
      expect(cardRng.rollRarity(), isFalse);
    });

    test('rollAttribute returns a value between the base value', () {
      when(rng.nextDouble).thenReturn(.3);
      expect(cardRng.rollAttribute(base: 10), equals(3));
    });

    test('rollAttribute adds the given modifier', () {
      when(rng.nextDouble).thenReturn(.3);
      expect(
        cardRng.rollAttribute(base: 10, modifier: 3),
        equals(6),
      );
    });
  });
}
