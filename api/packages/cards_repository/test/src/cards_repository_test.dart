// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cards_repository/cards_repository.dart';
import 'package:db_client/db_client.dart';
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

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('CardsRepository', () {
    late CardRng cardRng;
    late ImageModelRepository imageModelRepository;
    late LanguageModelRepository languageModelRepository;
    late CardsRepository cardsRepository;
    late DbClient dbClient;

    setUp(() {
      dbClient = _MockDbClient();
      cardRng = _MockCardRng();
      when(cardRng.rollRarity).thenReturn(false);
      when(
        () => cardRng.rollAttribute(
          base: 10,
          modifier: any(named: 'modifier'),
        ),
      ).thenReturn(10);
      when(
        () => cardRng.rollAttribute(
          base: Suit.values.length - 1,
          modifier: any(named: 'modifier'),
        ),
      ).thenReturn(Suit.air.index);
      imageModelRepository = _MockImageModelRepository();
      languageModelRepository = _MockLanguageModelRepository();

      cardsRepository = CardsRepository(
        imageModelRepository: imageModelRepository,
        languageModelRepository: languageModelRepository,
        dbClient: dbClient,
        rng: cardRng,
      );
    });

    test('can be instantiated', () {
      expect(
        CardsRepository(
          imageModelRepository: const ImageModelRepository(),
          languageModelRepository: const LanguageModelRepository(),
          dbClient: dbClient,
        ),
        isNotNull,
      );
    });

    group('generateCard', () {
      setUp(() {
        when(imageModelRepository.generateImage)
            .thenAnswer((_) async => 'https://image.png');

        when(languageModelRepository.generateCardName)
            .thenAnswer((_) async => 'Super Bird');
        when(languageModelRepository.generateFlavorText)
            .thenAnswer((_) async => 'Super Bird Is Ready!');

        when(() => dbClient.add('cards', any())).thenAnswer((_) async => 'abc');
      });

      test('generates a common card', () async {
        final card = await cardsRepository.generateCard();

        expect(
          card,
          Card(
            id: 'abc',
            name: 'Super Bird',
            description: 'Super Bird Is Ready!',
            image: 'https://image.png',
            rarity: false,
            power: 10,
            suit: Suit.air,
          ),
        );
      });

      test('saves the card in the db', () async {
        await cardsRepository.generateCard();

        verify(
          () => dbClient.add('cards', {
            'name': 'Super Bird',
            'description': 'Super Bird Is Ready!',
            'image': 'https://image.png',
            'rarity': false,
            'power': 10,
            'suit': 'air',
          }),
        ).called(1);
      });

      test('generates a rare card', () async {
        when(cardRng.rollRarity).thenReturn(true);
        final card = await cardsRepository.generateCard();

        expect(
          card,
          Card(
            id: 'abc',
            name: 'Super Bird',
            description: 'Super Bird Is Ready!',
            image: 'https://image.png',
            rarity: true,
            power: 10,
            suit: Suit.air,
          ),
        );

        verify(() => cardRng.rollAttribute(base: 10, modifier: 10)).called(1);
      });
    });

    group('createDeck', () {
      setUp(() {
        when(() => dbClient.add('decks', any()))
            .thenAnswer((_) async => 'deck');
      });

      test('creates a deck from a list of card ids', () async {
        final deckId = await cardsRepository.createDeck(
          cardIds: ['a', 'b'],
          userId: 'mock-userId',
        );

        expect(deckId, equals('deck'));
      });
    });

    group('getDeck', () {
      const deckId = 'deckId';
      const cardId = 'card1';
      const userId = 'userId';

      setUp(() {
        when(() => dbClient.getById('decks', any())).thenAnswer(
          (_) async => DbEntityRecord(
            id: deckId,
            data: const {
              'userId': userId,
              'cards': [cardId],
            },
          ),
        );

        when(() => dbClient.getById('cards', cardId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: cardId,
            data: const {
              'name': cardId,
              'description': cardId,
              'image': cardId,
              'power': 10,
              'rarity': false,
              'suit': 'air',
            },
          ),
        );
      });

      test('returns a deck', () async {
        final deck = await cardsRepository.getDeck(deckId);

        expect(
          deck,
          equals(
            Deck(
              userId: userId,
              id: deckId,
              cards: const [
                Card(
                  id: cardId,
                  name: cardId,
                  description: cardId,
                  image: cardId,
                  power: 10,
                  rarity: false,
                  suit: Suit.air,
                ),
              ],
            ),
          ),
        );
      });

      test('returns null when there is no deck for that id', () async {
        when(() => dbClient.getById('decks', any())).thenAnswer(
          (_) async => null,
        );
        final deck = await cardsRepository.getDeck(deckId);

        expect(deck, isNull);
      });
    });

    group('getCard', () {
      const cardId = 'cardId';

      const card = Card(
        id: cardId,
        name: 'name',
        description: 'description',
        image: 'image',
        power: 10,
        rarity: true,
        suit: Suit.air,
      );

      test('returns the card', () async {
        when(() => dbClient.getById('cards', cardId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: cardId,
            data: const {
              'name': 'name',
              'description': 'description',
              'image': 'image',
              'power': 10,
              'rarity': true,
              'suit': 'air',
            },
          ),
        );

        final returnedCard = await cardsRepository.getCard(cardId);
        expect(returnedCard, equals(card));
      });

      test('returns null if card if not found', () async {
        when(() => dbClient.getById('cards', cardId)).thenAnswer(
          (_) async => null,
        );

        final returnedCard = await cardsRepository.getCard(cardId);
        expect(returnedCard, isNull);
      });
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
