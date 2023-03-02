// ignore_for_file: prefer_const_constructors
import 'package:cards_repository/cards_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCardRepository extends Mock implements CardsRepository {}

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('MatchRepository', () {
    test('can be instantiated', () {
      expect(
        MatchRepository(
          cardsRepository: _MockCardRepository(),
          dbClient: _MockDbClient(),
        ),
        isNotNull,
      );
    });

    group('getMatch', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;

      const matchId = 'matchId';

      final cards = List.generate(
        6,
        (i) => Card(
          id: 'card_$i',
          name: 'card_$i',
          description: 'card_$i',
          image: 'card_$i',
          power: 10,
          rarity: false,
        ),
      );

      final hostDeck = Deck(
        id: 'hostDeckId',
        cards: [cards[0], cards[1], cards[2]],
      );

      final guestDeck = Deck(
        id: 'guestDeckId',
        cards: [cards[3], cards[4], cards[5]],
      );

      setUp(() {
        cardsRepository = _MockCardRepository();
        when(() => cardsRepository.getDeck(hostDeck.id))
            .thenAnswer((_) async => hostDeck);
        when(() => cardsRepository.getDeck(guestDeck.id))
            .thenAnswer((_) async => guestDeck);

        dbClient = _MockDbClient();

        when(() => dbClient.getById('matches', matchId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: matchId,
            data: {
              'host': hostDeck.id,
              'guest': guestDeck.id,
            },
          ),
        );

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
        );
      });

      test('returns the correct match', () async {
        final match = await matchRepository.getMatch(matchId);

        expect(
          match,
          equals(
            Match(
              id: matchId,
              hostDeck: hostDeck,
              guestDeck: guestDeck,
            ),
          ),
        );
      });

      test('returns null when there is no match', () async {
        when(() => dbClient.getById('matches', matchId)).thenAnswer(
          (_) async => null,
        );
        final match = await matchRepository.getMatch(matchId);

        expect(match, isNull);
      });

      test(
        'throws GetMatchFailure when for some reason, a deck is null',
        () async {
          when(() => cardsRepository.getDeck(guestDeck.id))
              .thenAnswer((_) async => null);

          expect(
            () async => matchRepository.getMatch(matchId),
            throwsA(
              isA<GetMatchFailure>(),
            ),
          );
        },
      );
    });
  });
}
