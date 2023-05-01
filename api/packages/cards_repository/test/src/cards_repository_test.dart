// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cards_repository/cards_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockImageModelRepository extends Mock implements ImageModelRepository {}

class _MockLanguageModelRepository extends Mock
    implements LanguageModelRepository {}

class _MockRandom extends Mock implements Random {}

class _MockDbClient extends Mock implements DbClient {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

void main() {
  group('CardsRepository', () {
    late ImageModelRepository imageModelRepository;
    late LanguageModelRepository languageModelRepository;
    late CardsRepository cardsRepository;
    late DbClient dbClient;
    late GameScriptMachine gameScriptMachine;
    late Random rng;

    setUpAll(() {
      registerFallbackValue(
        DbEntityRecord(
          id: 'id',
        ),
      );
    });

    setUp(() {
      dbClient = _MockDbClient();
      rng = _MockRandom();
      when(() => rng.nextInt(any())).thenReturn(0);

      gameScriptMachine = _MockGameScriptMachine();
      when(gameScriptMachine.rollCardRarity).thenReturn(false);
      when(
        () => gameScriptMachine.rollCardPower(
          isRare: any(named: 'isRare'),
        ),
      ).thenReturn(10);
      imageModelRepository = _MockImageModelRepository();
      languageModelRepository = _MockLanguageModelRepository();

      cardsRepository = CardsRepository(
        imageModelRepository: imageModelRepository,
        languageModelRepository: languageModelRepository,
        dbClient: dbClient,
        gameScriptMachine: gameScriptMachine,
        rng: rng,
      );
    });

    test('can be instantiated', () {
      expect(
        CardsRepository(
          imageModelRepository: _MockImageModelRepository(),
          languageModelRepository: _MockLanguageModelRepository(),
          dbClient: dbClient,
          gameScriptMachine: gameScriptMachine,
        ),
        isNotNull,
      );
    });

    group('generateCard', () {
      setUp(() {
        when(
          () => imageModelRepository.generateImages(
            characterClass: any(named: 'characterClass'),
            variationsAvailable: any(named: 'variationsAvailable'),
            deckSize: any(named: 'deckSize'),
          ),
        ).thenAnswer(
          (_) async => [
            ImageResult(
              character: 'dash',
              characterClass: 'mage',
              location: 'beach',
              url: 'https://image1.png',
            ),
            ImageResult(
              character: 'dash',
              characterClass: 'mage',
              location: 'beach',
              url: 'https://image2.png',
            ),
            ImageResult(
              character: 'dash',
              characterClass: 'mage',
              location: 'beach',
              url: 'https://image3.png',
            ),
          ],
        );

        when(
          () => languageModelRepository.generateCardName(
            characterName: 'dash',
            characterClass: 'mage',
            characterPower: 'baggles',
            characterLocation: 'beach',
          ),
        ).thenAnswer((_) async => 'Super Bird');
        when(
          () => languageModelRepository.generateFlavorText(
            character: 'dash',
            characterPower: 'baggles',
            location: 'beach',
          ),
        ).thenAnswer((_) async => 'Super Bird Is Ready!');

        when(() => dbClient.add('cards', any())).thenAnswer((_) async => 'abc');
      });

      test('generates a common card', () async {
        final cards = await cardsRepository.generateCards(
          characterClass: 'mage',
          characterPower: 'baggles',
        );

        expect(
          cards,
          equals(
            [
              Card(
                id: 'abc',
                name: 'Super Bird',
                description: 'Super Bird Is Ready!',
                image: 'https://image1.png',
                rarity: false,
                power: 10,
                suit: Suit.fire,
              ),
              Card(
                id: 'abc',
                name: 'Super Bird',
                description: 'Super Bird Is Ready!',
                image: 'https://image2.png',
                rarity: false,
                power: 10,
                suit: Suit.fire,
              ),
              Card(
                id: 'abc',
                name: 'Super Bird',
                description: 'Super Bird Is Ready!',
                image: 'https://image3.png',
                rarity: false,
                power: 10,
                suit: Suit.fire,
              ),
            ],
          ),
        );
      });

      test('saves the card in the db', () async {
        await cardsRepository.generateCards(
          characterClass: 'mage',
          characterPower: 'baggles',
        );

        verify(
          () => dbClient.add('cards', {
            'name': 'Super Bird',
            'description': 'Super Bird Is Ready!',
            'image': 'https://image1.png',
            'rarity': false,
            'power': 10,
            'suit': 'fire',
          }),
        ).called(1);
        verify(
          () => dbClient.add('cards', {
            'name': 'Super Bird',
            'description': 'Super Bird Is Ready!',
            'image': 'https://image2.png',
            'rarity': false,
            'power': 10,
            'suit': 'fire',
          }),
        ).called(1);
        verify(
          () => dbClient.add('cards', {
            'name': 'Super Bird',
            'description': 'Super Bird Is Ready!',
            'image': 'https://image3.png',
            'rarity': false,
            'power': 10,
            'suit': 'fire',
          }),
        ).called(1);
      });

      test('generates a rare card', () async {
        when(gameScriptMachine.rollCardRarity).thenReturn(true);
        final cards = await cardsRepository.generateCards(
          characterClass: 'mage',
          characterPower: 'baggles',
        );

        expect(
          cards,
          contains(
            Card(
              id: 'abc',
              name: 'Super Bird',
              description: 'Super Bird Is Ready!',
              image: 'https://image1.png',
              rarity: true,
              power: 10,
              suit: Suit.fire,
            ),
          ),
        );

        verify(() => gameScriptMachine.rollCardPower(isRare: true)).called(3);
      });

      for (var i = 0; i < Suit.values.length; i++) {
        test('generates a card from the ${Suit.values[i]} element', () async {
          when(() => rng.nextInt(Suit.values.length)).thenReturn(i);
          final cards = await cardsRepository.generateCards(
            characterClass: 'mage',
            characterPower: 'baggles',
          );

          expect(
            cards,
            contains(
              Card(
                id: 'abc',
                name: 'Super Bird',
                description: 'Super Bird Is Ready!',
                image: 'https://image1.png',
                rarity: false,
                power: 10,
                suit: Suit.values[i],
              ),
            ),
          );
        });
      }
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
      const userId = 'userId';
      const cardId = 'card1';

      setUp(() {
        when(() => dbClient.getById('decks', any())).thenAnswer(
          (_) async => DbEntityRecord(
            id: deckId,
            data: const {
              'userId': userId,
              'cards': [cardId],
              'shareImage': 'https://share-image.png',
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
              id: deckId,
              userId: userId,
              shareImage: 'https://share-image.png',
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
        suit: Suit.fire,
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
              'suit': 'fire',
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

    group('updateCard', () {
      test('updates a card', () async {
        final card = Card(
          id: 'abc',
          name: 'Super Bird',
          description: 'Super Bird Is Ready!',
          image: 'https://image.png',
          rarity: false,
          power: 10,
          suit: Suit.fire,
          shareImage: 'https://share.png',
        );

        when(() => dbClient.update('cards', any())).thenAnswer(
          (_) async {},
        );

        await cardsRepository.updateCard(card);

        verify(
          () => dbClient.update(
            'cards',
            DbEntityRecord(
              id: card.id,
              data: const {
                'name': 'Super Bird',
                'description': 'Super Bird Is Ready!',
                'image': 'https://image.png',
                'rarity': false,
                'power': 10,
                'suit': 'fire',
                'shareImage': 'https://share.png',
              },
            ),
          ),
        ).called(1);
      });
    });

    group('updateDeck', () {
      test('updates a deck', () async {
        final deck = Deck(
          id: 'abc',
          userId: 'userId',
          shareImage: 'https://share.png',
          cards: const [
            Card(
              id: 'card1',
              name: 'Super Bird',
              description: 'Super Bird Is Ready!',
              image: 'https://image.png',
              rarity: false,
              power: 10,
              suit: Suit.air,
              shareImage: 'https://share.png',
            ),
          ],
        );

        when(() => dbClient.update('decks', any())).thenAnswer(
          (_) async {},
        );

        await cardsRepository.updateDeck(deck);

        verify(
          () => dbClient.update(
            'decks',
            DbEntityRecord(
              id: deck.id,
              data: const {
                'userId': 'userId',
                'shareImage': 'https://share.png',
                'cards': ['card1'],
              },
            ),
          ),
        ).called(1);
      });
    });
  });
}
