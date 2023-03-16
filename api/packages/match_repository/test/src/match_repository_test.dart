// ignore_for_file: prefer_const_constructors
import 'package:cards_repository/cards_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCardRepository extends Mock implements CardsRepository {}

class _MockDbClient extends Mock implements DbClient {}

class _MockMatchSolver extends Mock implements MatchSolver {}

void main() {
  group('MatchRepository', () {
    setUpAll(() {
      registerFallbackValue(DbEntityRecord(id: ''));
      registerFallbackValue(
        Match(
          id: '',
          guestDeck: Deck(userId: 'guestId', id: '', cards: const []),
          hostDeck: Deck(userId: 'hostId', id: '', cards: const []),
        ),
      );
      registerFallbackValue(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        MatchRepository(
          cardsRepository: _MockCardRepository(),
          dbClient: _MockDbClient(),
          matchSolver: _MockMatchSolver(),
        ),
        isNotNull,
      );
    });

    group('getMatch', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;
      late MatchSolver matchSolver;

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
          suit: Suit.values[i % Suit.values.length],
        ),
      );

      final hostDeck = Deck(
        userId: 'hostId',
        id: 'hostDeckId',
        cards: [cards[0], cards[1], cards[2]],
      );

      final guestDeck = Deck(
        userId: 'guestId',
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

        matchSolver = _MockMatchSolver();

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
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

    group('getScoreCard', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;
      late MatchSolver matchSolver;
      const scoreCardId = 'scoreCardId';
      final scoreCard = ScoreCard(
        id: scoreCardId,
        wins: 1,
        currentStreak: 1,
        longestStreak: 1,
      );

      setUp(() {
        cardsRepository = _MockCardRepository();

        dbClient = _MockDbClient();

        when(() => dbClient.getById('score_cards', scoreCardId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: scoreCardId,
            data: {
              'wins': scoreCard.wins,
              'currentStreak': scoreCard.currentStreak,
              'longestStreak': scoreCard.longestStreak,
            },
          ),
        );

        matchSolver = _MockMatchSolver();

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );
      });

      test('returns the correct ScoreCard', () async {
        final result = await matchRepository.getScoreCard(scoreCardId);

        expect(result, equals(scoreCard));
      });

      test('returns empty score card when there is no match', () async {
        when(() => dbClient.getById('score_cards', scoreCardId)).thenAnswer(
          (_) async => null,
        );
        when(
          () => dbClient.create(
            'score_cards',
            DbEntityRecord(
              id: scoreCardId,
              data: const {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 0,
              },
            ),
          ),
        ).thenAnswer(
          (_) async {},
        );
        final result = await matchRepository.getScoreCard(scoreCardId);

        expect(result, ScoreCard(id: scoreCardId));
      });
    });

    group('getMatchState', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;
      late MatchSolver matchSolver;

      const matchId = 'matchId';
      const matchStateId = 'matchStateId';

      setUp(() {
        matchSolver = _MockMatchSolver();
        cardsRepository = _MockCardRepository();

        dbClient = _MockDbClient();

        when(() => dbClient.findBy('match_states', 'matchId', matchId))
            .thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'guestPlayedCards': ['A', 'B'],
                'hostPlayedCards': ['C', 'D'],
              },
            ),
          ],
        );

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );
      });

      test('returns the correct match state', () async {
        final matchState = await matchRepository.getMatchState(matchId);

        expect(
          matchState,
          equals(
            MatchState(
              id: matchStateId,
              matchId: matchId,
              guestPlayedCards: const ['A', 'B'],
              hostPlayedCards: const ['C', 'D'],
            ),
          ),
        );
      });

      test('returns null when there is no match', () async {
        when(() => dbClient.findBy('match_states', 'matchId', matchId))
            .thenAnswer(
          (_) async => [],
        );
        final matchState = await matchRepository.getMatchState(matchId);

        expect(matchState, isNull);
      });
    });

    group('playCard', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;
      late MatchSolver matchSolver;

      const matchId = 'matchId';
      const matchStateId = 'matchStateId';

      final cards = List.generate(
        6,
        (i) => Card(
          id: 'card_$i',
          name: 'card_$i',
          description: 'card_$i',
          image: 'card_$i',
          power: 10,
          rarity: false,
          suit: Suit.values[i % Suit.values.length],
        ),
      );

      final hostDeck = Deck(
        userId: 'hostId',
        id: 'hostDeckId',
        cards: [cards[0], cards[1], cards[2]],
      );

      final guestDeck = Deck(
        userId: 'guestId',
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

        when(() => dbClient.getById('score_cards', any())).thenAnswer(
          (_) async => DbEntityRecord(
            id: 'scoreCardId',
          ),
        );

        when(() => dbClient.findBy('match_states', 'matchId', matchId))
            .thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'guestPlayedCards': <String>[],
                'hostPlayedCards': <String>[],
              },
            ),
          ],
        );

        when(() => dbClient.update(any(), any())).thenAnswer((_) async {});

        matchSolver = _MockMatchSolver();

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );
      });

      test('correctly updates the match state when is guest', () async {
        await matchRepository.playCard(
          matchId: matchId,
          cardId: 'A',
          deckId: guestDeck.id,
          userId: guestDeck.userId,
        );

        verify(
          () => dbClient.update(
            'match_states',
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'hostPlayedCards': <String>[],
                'guestPlayedCards': ['A'],
                'result': null,
              },
            ),
          ),
        ).called(1);
      });

      test('correctly updates the match state when is host', () async {
        await matchRepository.playCard(
          matchId: matchId,
          cardId: 'A',
          deckId: hostDeck.id,
          userId: hostDeck.userId,
        );

        verify(
          () => dbClient.update(
            'match_states',
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'hostPlayedCards': <String>['A'],
                'guestPlayedCards': <String>[],
                'result': null,
              },
            ),
          ),
        ).called(1);
      });

      test('when the match is over, updates the result', () async {
        when(() => dbClient.findBy('match_states', 'matchId', matchId))
            .thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'guestPlayedCards': <String>['A', 'B', 'C'],
                'hostPlayedCards': <String>['D', 'E'],
              },
            ),
          ],
        );

        when(() => matchSolver.calculateMatchResult(any(), any()))
            .thenReturn(MatchResult.host);

        await matchRepository.playCard(
          matchId: matchId,
          cardId: 'F',
          deckId: hostDeck.id,
          userId: hostDeck.userId,
        );

        verify(
          () => dbClient.update(
            'match_states',
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'hostPlayedCards': <String>['D', 'E', 'F'],
                'guestPlayedCards': <String>['A', 'B', 'C'],
                'result': 'host',
              },
            ),
          ),
        ).called(1);
      });

      test('throws PlayCardFailure when match state is not found', () async {
        when(() => dbClient.findBy('match_states', 'matchId', matchId))
            .thenAnswer((_) async => []);

        await expectLater(
          () => matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            deckId: hostDeck.id,
            userId: hostDeck.userId,
          ),
          throwsA(isA<PlayCardFailure>()),
        );
      });

      test(
        "throws PlayCardFailure when match is over, and its match can't be "
        'found',
        () async {
          when(() => dbClient.findBy('match_states', 'matchId', matchId))
              .thenAnswer(
            (_) async => [
              DbEntityRecord(
                id: matchStateId,
                data: const {
                  'matchId': matchId,
                  'guestPlayedCards': <String>['A', 'B', 'C'],
                  'hostPlayedCards': <String>['D', 'E'],
                },
              ),
            ],
          );

          when(() => dbClient.getById('matches', matchId)).thenAnswer(
            (_) async => null,
          );

          await expectLater(
            () => matchRepository.playCard(
              matchId: matchId,
              cardId: 'F',
              deckId: hostDeck.id,
              userId: hostDeck.userId,
            ),
            throwsA(isA<PlayCardFailure>()),
          );
        },
      );

      group('score card', () {
        setUp(() {
          when(() => dbClient.findBy('match_states', 'matchId', matchId))
              .thenAnswer(
            (_) async => [
              DbEntityRecord(
                id: matchStateId,
                data: const {
                  'matchId': matchId,
                  'guestPlayedCards': <String>['A', 'B', 'C'],
                  'hostPlayedCards': <String>['D', 'E'],
                },
              ),
            ],
          );
        });

        test('updates correctly when host wins', () async {
          when(() => matchSolver.calculateMatchResult(any(), any()))
              .thenReturn(MatchResult.host);

          await matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            isHost: true,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: hostDeck.userId,
                data: const {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 1,
                },
              ),
            ),
          ).called(1);

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: guestDeck.userId,
                data: const {
                  'currentStreak': 0,
                },
              ),
            ),
          ).called(1);
        });

        test('updates correctly when guest wins', () async {
          when(() => matchSolver.calculateMatchResult(any(), any()))
              .thenReturn(MatchResult.guest);

          await matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            isHost: true,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: guestDeck.userId,
                data: const {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 1,
                },
              ),
            ),
          ).called(1);

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: hostDeck.userId,
                data: const {
                  'currentStreak': 0,
                },
              ),
            ),
          ).called(1);
        });

        test('do not update when there is a draw', () async {
          when(() => matchSolver.calculateMatchResult(any(), any()))
              .thenReturn(MatchResult.draw);

          await matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            isHost: true,
          );

          verifyNever(
            () => dbClient.update(
              'score_cards',
              any(),
            ),
          );
        });
      });
    });
  });
}
