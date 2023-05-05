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
          guestDeck: Deck(id: '', userId: '', cards: const []),
          hostDeck: Deck(id: '', userId: '', cards: const []),
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
        id: 'hostDeckId',
        userId: 'hostUserId',
        cards: [cards[0], cards[1], cards[2]],
      );

      final guestDeck = Deck(
        id: 'guestDeckId',
        userId: 'guestUserId',
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

    group('IsDraftMatch', () {
      late DbClient dbClient;
      late MatchRepository matchRepository;

      const matchId = 'matchId';
      const hostDeckId = 'hostDeckId';
      const guestDeckId = 'guestDeckId';

      setUp(() {
        dbClient = _MockDbClient();

        matchRepository = MatchRepository(
          cardsRepository: _MockCardRepository(),
          dbClient: dbClient,
          matchSolver: _MockMatchSolver(),
        );
      });

      test('returns false when guest exists', () async {
        when(() => dbClient.getById('matches', matchId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: matchId,
            data: const {
              'host': hostDeckId,
              'guest': guestDeckId,
            },
          ),
        );
        final isDraftMatch = await matchRepository.isDraftMatch(matchId);

        expect(isDraftMatch, isFalse);
      });

      test('returns true when guest is empty', () async {
        when(() => dbClient.getById('matches', matchId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: matchId,
            data: const {
              'host': hostDeckId,
              'guest': emptyKey,
            },
          ),
        );
        final isDraftMatch = await matchRepository.isDraftMatch(matchId);

        expect(isDraftMatch, isTrue);
      });
    });

    group('getScoreCard', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;
      late MatchSolver matchSolver;
      const scoreCardId = 'scoreCardId';
      const deckId = 'deckId';
      final scoreCard = ScoreCard(
        id: scoreCardId,
        wins: 1,
        currentStreak: 1,
        longestStreak: 1,
        currentDeck: deckId,
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
              'currentDeck': deckId,
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
        final result = await matchRepository.getScoreCard(scoreCardId, deckId);

        expect(result, equals(scoreCard));
      });

      test('returns empty score card when there is no match', () async {
        when(() => dbClient.getById('score_cards', scoreCardId)).thenAnswer(
          (_) async => null,
        );
        when(
          () => dbClient.set(
            'score_cards',
            DbEntityRecord(
              id: scoreCardId,
              data: const {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 0,
                'currentDeck': deckId,
              },
            ),
          ),
        ).thenAnswer(
          (_) async {},
        );
        final result = await matchRepository.getScoreCard(scoreCardId, deckId);

        expect(result, ScoreCard(id: scoreCardId, currentDeck: deckId));
      });
    });

    group('getMatchState', () {
      late CardsRepository cardsRepository;
      late DbClient dbClient;
      late MatchRepository matchRepository;
      late MatchSolver matchSolver;

      const matchId = 'matchId';
      const deckId = 'deckId';
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
                'currentDeck': deckId,
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
        id: 'hostDeckId',
        userId: 'hostUserId',
        cards: [cards[0], cards[1], cards[2]],
      );

      final guestDeck = Deck(
        id: 'guestDeckId',
        userId: 'guestUserId',
        cards: [cards[3], cards[4], cards[5]],
      );

      setUp(() {
        cardsRepository = _MockCardRepository();
        when(() => cardsRepository.getDeck(hostDeck.id))
            .thenAnswer((_) async => hostDeck);
        when(() => cardsRepository.getDeck(guestDeck.id))
            .thenAnswer((_) async => guestDeck);

        dbClient = _MockDbClient();

        when(() => dbClient.getById('score_cards', any())).thenAnswer(
          (_) async => DbEntityRecord(
            id: 'scoreCardId',
          ),
        );

        when(() => dbClient.getById('matches', matchId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: matchId,
            data: {
              'host': hostDeck.id,
              'guest': guestDeck.id,
            },
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

        when(
          () => matchSolver.canPlayCard(
            any(),
            any(),
            isHost: any(named: 'isHost'),
          ),
        ).thenReturn(true);

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
                'result': null,
              },
            ),
          ),
        ).called(1);
      });

      test(
        'correctly updates the match state when is against cpu '
        'and plays only one cpu card',
        () async {
          final cpuDeck = Deck(
            id: 'guestDeckId',
            userId: 'CPU_UserId',
            cards: [cards[3], cards[4], cards[5]],
          );
          when(() => cardsRepository.getDeck(guestDeck.id))
              .thenAnswer((_) async => cpuDeck);

          when(() => dbClient.findBy('match_states', 'matchId', matchId))
              .thenAnswer(
            (_) async => [
              DbEntityRecord(
                id: matchStateId,
                data: const {
                  'matchId': matchId,
                  'hostPlayedCards': <String>[],
                  'guestPlayedCards': <String>[],
                  'result': null,
                },
              )
            ],
          );

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
                  'result': null,
                },
              ),
            ),
          ).called(1);

          when(() => dbClient.findBy('match_states', 'matchId', matchId))
              .thenAnswer(
            (_) async => [
              DbEntityRecord(
                id: matchStateId,
                data: const {
                  'matchId': matchId,
                  'hostPlayedCards': <String>['A'],
                  'guestPlayedCards': <String>[],
                  'result': null,
                },
              )
            ],
          );

          await Future<void>.delayed(const Duration(seconds: 4));
          verify(
            () => dbClient.update(
              'match_states',
              DbEntityRecord(
                id: matchStateId,
                data: const {
                  'matchId': matchId,
                  'guestPlayedCards': <String>['card_3'],
                  'result': null,
                },
              ),
            ),
          ).called(1);

          verifyNever(() => dbClient.update('match_states', any()));
        },
      );

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

      test('throws PlayCardFailure when card has already been played',
          () async {
        when(
          () => matchSolver.canPlayCard(
            any(),
            any(),
            isHost: any(named: 'isHost'),
          ),
        ).thenReturn(false);

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
          when(() => dbClient.getById('score_cards', hostDeck.userId))
              .thenAnswer(
            (_) async => DbEntityRecord(
              id: hostDeck.userId,
              data: const {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 0,
                'currentDeck': 'anyId',
              },
            ),
          );

          await matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            deckId: hostDeck.id,
            userId: hostDeck.userId,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: hostDeck.userId,
                data: {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 1,
                  'longestStreakDeck': hostDeck.id,
                  'currentDeck': hostDeck.id,
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
          when(() => dbClient.getById('score_cards', guestDeck.userId))
              .thenAnswer(
            (_) async => DbEntityRecord(
              id: guestDeck.userId,
              data: const {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 0,
                'currentDeck': 'anyId',
              },
            ),
          );

          await matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            deckId: hostDeck.id,
            userId: hostDeck.userId,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: guestDeck.userId,
                data: {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 1,
                  'currentDeck': guestDeck.id,
                  'longestStreakDeck': guestDeck.id,
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

        test('updates correctly when any player wins but is not longest streak',
            () async {
          when(() => matchSolver.calculateMatchResult(any(), any()))
              .thenReturn(MatchResult.guest);
          when(() => dbClient.getById('score_cards', guestDeck.userId))
              .thenAnswer(
            (_) async => DbEntityRecord(
              id: guestDeck.userId,
              data: {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 2,
                'currentDeck': guestDeck.id,
                'longestStreakDeck': 'longestStreakDeckId'
              },
            ),
          );

          await matchRepository.playCard(
            matchId: matchId,
            cardId: 'F',
            deckId: hostDeck.id,
            userId: hostDeck.userId,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: guestDeck.userId,
                data: {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 2,
                  'currentDeck': guestDeck.id,
                  'longestStreakDeck': 'longestStreakDeckId',
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
            deckId: hostDeck.id,
            userId: hostDeck.userId,
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

    group('calculateMatchResult', () {
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
        id: 'hostDeckId',
        userId: 'hostUserId',
        cards: [cards[0], cards[1], cards[2]],
      );

      final guestDeck = Deck(
        id: 'guestDeckId',
        userId: 'guestUserId',
        cards: [cards[3], cards[4], cards[5]],
      );

      setUp(() {
        cardsRepository = _MockCardRepository();
        when(() => cardsRepository.getDeck(hostDeck.id))
            .thenAnswer((_) async => hostDeck);
        when(() => cardsRepository.getDeck(guestDeck.id))
            .thenAnswer((_) async => guestDeck);

        dbClient = _MockDbClient();

        when(() => dbClient.getById('score_cards', any())).thenAnswer(
          (_) async => DbEntityRecord(
            id: 'scoreCardId',
          ),
        );

        when(() => dbClient.getById('matches', matchId)).thenAnswer(
          (_) async => DbEntityRecord(
            id: matchId,
            data: {
              'host': hostDeck.id,
              'guest': guestDeck.id,
            },
          ),
        );

        when(() => dbClient.findBy('match_states', 'matchId', matchId))
            .thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: matchStateId,
              data: const {
                'matchId': matchId,
                'guestPlayedCards': <String>['A', 'B', 'C'],
                'hostPlayedCards': <String>['D', 'E', 'F'],
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

      test('correctly updates the match state when host wins', () async {
        when(() => matchSolver.calculateMatchResult(any(), any()))
            .thenReturn(MatchResult.host);
        final match =
            Match(id: matchId, hostDeck: hostDeck, guestDeck: guestDeck);
        final matchState = MatchState(
          id: matchStateId,
          matchId: matchId,
          hostPlayedCards: const ['D', 'E', 'F'],
          guestPlayedCards: const ['A', 'B', 'C'],
        );

        await matchRepository.calculateMatchResult(
          match: match,
          matchState: matchState,
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

      test('throws CalculateResultFailure when match is not over', () async {
        final match = Match(id: 'id', hostDeck: hostDeck, guestDeck: guestDeck);
        final matchState = MatchState(
          id: 'matchStateId',
          matchId: matchId,
          hostPlayedCards: const ['A'],
          guestPlayedCards: const ['B'],
        );

        await expectLater(
          () => matchRepository.calculateMatchResult(
            match: match,
            matchState: matchState,
          ),
          throwsA(isA<CalculateResultFailure>()),
        );
      });

      test(
        'throws CalculateResultFailure when match is over and already has a '
        'result',
        () async {
          final match =
              Match(id: 'id', hostDeck: hostDeck, guestDeck: guestDeck);
          final matchState = MatchState(
            id: 'matchStateId',
            matchId: matchId,
            hostPlayedCards: const ['A', 'B', 'C'],
            guestPlayedCards: const ['D', 'E', 'F'],
            result: MatchResult.draw,
          );

          await expectLater(
            () => matchRepository.calculateMatchResult(
              match: match,
              matchState: matchState,
            ),
            throwsA(isA<CalculateResultFailure>()),
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
                  'hostPlayedCards': <String>['D', 'E', 'F'],
                },
              ),
            ],
          );
        });

        test('updates correctly when host wins', () async {
          when(() => matchSolver.calculateMatchResult(any(), any()))
              .thenReturn(MatchResult.host);
          when(() => dbClient.getById('score_cards', hostDeck.userId))
              .thenAnswer(
            (_) async => DbEntityRecord(
              id: hostDeck.userId,
              data: const {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 0,
                'currentDeck': 'anyId',
              },
            ),
          );

          final match =
              Match(id: 'id', hostDeck: hostDeck, guestDeck: guestDeck);
          final matchState = MatchState(
            id: 'matchStateId',
            matchId: matchId,
            hostPlayedCards: const ['A', 'B', 'C'],
            guestPlayedCards: const ['D', 'E', 'F'],
          );

          await matchRepository.calculateMatchResult(
            match: match,
            matchState: matchState,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: hostDeck.userId,
                data: {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 1,
                  'longestStreakDeck': hostDeck.id,
                  'currentDeck': hostDeck.id,
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
          when(() => dbClient.getById('score_cards', guestDeck.userId))
              .thenAnswer(
            (_) async => DbEntityRecord(
              id: guestDeck.userId,
              data: const {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 0,
                'currentDeck': 'anyId',
              },
            ),
          );

          final match =
              Match(id: 'id', hostDeck: hostDeck, guestDeck: guestDeck);
          final matchState = MatchState(
            id: 'matchStateId',
            matchId: matchId,
            hostPlayedCards: const ['A', 'B', 'C'],
            guestPlayedCards: const ['D', 'E', 'F'],
          );

          await matchRepository.calculateMatchResult(
            match: match,
            matchState: matchState,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: guestDeck.userId,
                data: {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 1,
                  'currentDeck': guestDeck.id,
                  'longestStreakDeck': guestDeck.id,
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

        test('updates correctly when any player wins but is not longest streak',
            () async {
          when(() => matchSolver.calculateMatchResult(any(), any()))
              .thenReturn(MatchResult.guest);
          when(() => dbClient.getById('score_cards', guestDeck.userId))
              .thenAnswer(
            (_) async => DbEntityRecord(
              id: guestDeck.userId,
              data: {
                'wins': 0,
                'currentStreak': 0,
                'longestStreak': 2,
                'currentDeck': guestDeck.id,
                'longestStreakDeck': 'longestStreakDeckId'
              },
            ),
          );

          final match =
              Match(id: 'id', hostDeck: hostDeck, guestDeck: guestDeck);
          final matchState = MatchState(
            id: 'matchStateId',
            matchId: matchId,
            hostPlayedCards: const ['A', 'B', 'C'],
            guestPlayedCards: const ['D', 'E', 'F'],
          );

          await matchRepository.calculateMatchResult(
            match: match,
            matchState: matchState,
          );

          verify(
            () => dbClient.update(
              'score_cards',
              DbEntityRecord(
                id: guestDeck.userId,
                data: {
                  'wins': 1,
                  'currentStreak': 1,
                  'longestStreak': 2,
                  'currentDeck': guestDeck.id,
                  'longestStreakDeck': 'longestStreakDeckId',
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

          final match =
              Match(id: 'id', hostDeck: hostDeck, guestDeck: guestDeck);
          final matchState = MatchState(
            id: 'matchStateId',
            matchId: matchId,
            hostPlayedCards: const ['A', 'B', 'C'],
            guestPlayedCards: const ['D', 'E', 'F'],
          );

          await matchRepository.calculateMatchResult(
            match: match,
            matchState: matchState,
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

    group('setCpuConnectivity', () {
      late final MatchRepository matchRepository;
      final dbClient = _MockDbClient();
      final cardsRepository = _MockCardRepository();
      final matchSolver = _MockMatchSolver();
      const matchId = 'matchId';
      const deckId = 'deckId';

      setUp(() {
        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );
        when(() => dbClient.update(any(), any<DbEntityRecord>()))
            .thenAnswer((_) async {});
      });

      test('updates the correct field', () async {
        await matchRepository.setCpuConnectivity(
          matchId: matchId,
          deckId: deckId,
        );
        verify(
          () => dbClient.update(
            'matches',
            DbEntityRecord(
              id: matchId,
              data: const {
                'guestConnected': true,
                'guest': deckId,
              },
            ),
          ),
        );
      });
    });

    group('setGuestConnectivity', () {
      late final MatchRepository matchRepository;
      final dbClient = _MockDbClient();
      final cardsRepository = _MockCardRepository();
      final matchSolver = _MockMatchSolver();
      const matchId = 'matchId';

      setUp(() {
        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );
        when(() => dbClient.update(any(), any<DbEntityRecord>()))
            .thenAnswer((_) async {});
      });

      test('updates the correct field', () async {
        await matchRepository.setGuestConnectivity(
          match: matchId,
          active: true,
        );
        verify(
          () => dbClient.update(
            'matches',
            DbEntityRecord(
              id: matchId,
              data: const {
                'guestConnected': true,
              },
            ),
          ),
        );

        await matchRepository.setGuestConnectivity(
          match: matchId,
          active: false,
        );
        verify(
          () => dbClient.update(
            'matches',
            DbEntityRecord(
              id: matchId,
              data: const {
                'guestConnected': false,
              },
            ),
          ),
        );
      });
    });

    group('setHostConnectivity', () {
      late DbClient dbClient;
      late MatchRepository matchRepository;
      const matchId = 'matchId';

      setUp(() {
        dbClient = _MockDbClient();

        final cardsRepository = _MockCardRepository();
        final matchSolver = _MockMatchSolver();

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );
        when(() => dbClient.update(any(), any<DbEntityRecord>()))
            .thenAnswer((_) async {});
      });

      test('updates the correct field', () async {
        await matchRepository.setHostConnectivity(
          match: matchId,
          active: true,
        );
        verify(
          () => dbClient.update(
            'matches',
            DbEntityRecord(
              id: matchId,
              data: const {
                'hostConnected': true,
              },
            ),
          ),
        );

        await matchRepository.setHostConnectivity(
          match: matchId,
          active: false,
        );
        verify(
          () => dbClient.update(
            'matches',
            DbEntityRecord(
              id: matchId,
              data: const {
                'hostConnected': false,
              },
            ),
          ),
        );
      });
    });

    group('getPlayerConnectivity', () {
      late DbClient dbClient;
      late MatchRepository matchRepository;
      const userId = 'userId';

      setUp(() {
        dbClient = _MockDbClient();
        final cardsRepository = _MockCardRepository();
        final matchSolver = _MockMatchSolver();

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );

        when(() => dbClient.getById(any(), any())).thenAnswer(
          (_) async => DbEntityRecord(
            id: userId,
            data: const {
              'connected': true,
            },
          ),
        );
      });

      test('returns the correct result', () async {
        final result = await matchRepository.getPlayerConnectivity(
          userId: userId,
        );

        expect(result, isTrue);
        verify(() => dbClient.getById('connection_states', userId)).called(1);
      });
    });

    group('setPlayerConnectivity', () {
      late DbClient dbClient;
      late MatchRepository matchRepository;
      const userId = 'userId';

      setUp(() {
        dbClient = _MockDbClient();
        final cardsRepository = _MockCardRepository();
        final matchSolver = _MockMatchSolver();

        matchRepository = MatchRepository(
          cardsRepository: cardsRepository,
          dbClient: dbClient,
          matchSolver: matchSolver,
        );

        when(() => dbClient.update(any(), any())).thenAnswer((_) async {});
      });

      test('updates data on the dbClient', () async {
        await matchRepository.setPlayerConnectivity(
          userId: userId,
          connected: false,
        );

        verify(
          () => dbClient.update(
            'connection_states',
            DbEntityRecord(
              id: userId,
              data: const {'connected': false},
            ),
          ),
        ).called(1);
      });
    });
  });
}
