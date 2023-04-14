import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/leaderboard/results/index.dart' as route;

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    late LeaderboardRepository leaderboardRepository;
    late Request request;
    late RequestContext context;

    const scoreCards = [
      ScoreCard(
        id: 'id',
        wins: 1,
        longestStreak: 1,
        currentStreak: 1,
        currentDeck: 'deckId',
        longestStreakDeck: 'longestId',
        initials: 'initials',
      ),
      ScoreCard(
        id: 'id2',
        wins: 2,
        longestStreak: 2,
        currentStreak: 2,
        currentDeck: 'deckId2',
        longestStreakDeck: 'longestId2',
        initials: 'initials2',
      ),
      ScoreCard(
        id: 'id3',
        wins: 3,
        longestStreak: 3,
        currentStreak: 3,
        currentDeck: 'deckId3',
        longestStreakDeck: 'longestId3',
        initials: 'initials3',
      ),
    ];

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();
      when(
        () => leaderboardRepository.getScoreCardsWithMostWins(),
      ).thenAnswer(
        (_) async => scoreCards,
      );
      when(
        () => leaderboardRepository.getScoreCardsWithLongestStreak(),
      ).thenAnswer(
        (_) async => scoreCards,
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('only allows get methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with the list score cards', () async {
      final response = await route.onRequest(context);

      final json = await response.json();
      expect(
        json,
        equals({
          'scoreCardsWithMostWins': [
            {
              'id': 'id',
              'wins': 1,
              'longestStreak': 1,
              'currentStreak': 1,
              'currentDeck': 'deckId',
              'longestStreakDeck': 'longestId',
              'initials': 'initials',
            },
            {
              'id': 'id2',
              'wins': 2,
              'longestStreak': 2,
              'currentStreak': 2,
              'currentDeck': 'deckId2',
              'longestStreakDeck': 'longestId2',
              'initials': 'initials2',
            },
            {
              'id': 'id3',
              'wins': 3,
              'longestStreak': 3,
              'currentStreak': 3,
              'currentDeck': 'deckId3',
              'longestStreakDeck': 'longestId3',
              'initials': 'initials3',
            },
          ],
          'scoreCardsWithLongestStreak': [
            {
              'id': 'id',
              'wins': 1,
              'longestStreak': 1,
              'currentStreak': 1,
              'currentDeck': 'deckId',
              'longestStreakDeck': 'longestId',
              'initials': 'initials',
            },
            {
              'id': 'id2',
              'wins': 2,
              'longestStreak': 2,
              'currentStreak': 2,
              'currentDeck': 'deckId2',
              'longestStreakDeck': 'longestId2',
              'initials': 'initials2',
            },
            {
              'id': 'id3',
              'wins': 3,
              'longestStreak': 3,
              'currentStreak': 3,
              'currentDeck': 'deckId3',
              'longestStreakDeck': 'longestId3',
              'initials': 'initials3',
            },
          ],
        }),
      );
    });

    test('responds with the exception thrown', () async {
      when(
        () => leaderboardRepository.getScoreCardsWithMostWins(),
      ).thenThrow(Exception('oops'));

      final response = await route.onRequest(context);

      final json = await response.json();
      expect(json, equals('Exception: oops'));
    });
  });
}
