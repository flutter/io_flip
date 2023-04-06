// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('LeaderboardRepository', () {
    late DbClient dbClient;
    late LeaderboardRepository leaderboardRepository;

    const blacklistDocumentId = 'id';

    setUp(() {
      dbClient = _MockDbClient();
      leaderboardRepository = LeaderboardRepository(
        dbClient: dbClient,
        blacklistDocumentId: blacklistDocumentId,
      );
    });

    test('can be instantiated', () {
      expect(
        LeaderboardRepository(
          dbClient: dbClient,
          blacklistDocumentId: blacklistDocumentId,
        ),
        isNotNull,
      );
    });

    group('getInitialsBlacklist', () {
      const blacklist = ['AAA', 'BBB', 'CCC'];

      test('returns the blacklist', () async {
        when(() => dbClient.getById('initials_blacklist', blacklistDocumentId))
            .thenAnswer(
          (_) async => DbEntityRecord(
            id: blacklistDocumentId,
            data: const {
              'blacklist': ['AAA', 'BBB', 'CCC'],
            },
          ),
        );
        final response = await leaderboardRepository.getInitialsBlacklist();
        expect(response, equals(blacklist));
      });

      test('returns empty list if not found', () async {
        when(() => dbClient.getById('initials_blacklist', any())).thenAnswer(
          (_) async => null,
        );
        final response = await leaderboardRepository.getInitialsBlacklist();
        expect(response, isEmpty);
      });
    });

    group('findScoreCardByLongestStreakDeck', () {
      test('returns the score card', () async {
        const deckId = 'deckId';
        final scoreCard = ScoreCard(
          id: '',
          wins: 2,
          currentStreak: 2,
          longestStreak: 3,
          longestStreakDeck: deckId,
        );

        when(() => dbClient.findBy('score_cards', 'longestStreakDeck', deckId))
            .thenAnswer((_) async {
          return [
            DbEntityRecord(
              id: '',
              data: {
                'wins': scoreCard.wins,
                'currentStreak': scoreCard.currentStreak,
                'longestStreak': scoreCard.longestStreak,
                'longestStreakDeck': deckId,
              },
            ),
          ];
        });

        final result = await leaderboardRepository
            .findScoreCardByLongestStreakDeck(deckId);

        expect(result, equals(scoreCard));
      });

      test('returns null when no score card is to be found', () async {
        const deckId = 'deckId';

        when(() => dbClient.findBy('score_cards', 'longestStreakDeck', deckId))
            .thenAnswer((_) async {
          return [];
        });

        final result = await leaderboardRepository
            .findScoreCardByLongestStreakDeck(deckId);

        expect(result, isNull);
      });
    });

    group('isInitialsAvailable', () {
      test('returns true if results is empty', () async {
        const initials = 'AAA';

        when(() => dbClient.findBy('score_cards', 'initials', initials))
            .thenAnswer((_) async {
          return [];
        });

        final result =
            await leaderboardRepository.isInitialsAvailable(initials);

        expect(result, isTrue);
      });

      test('returns false if results is not empty', () async {
        const initials = 'AAA';

        when(() => dbClient.findBy('score_cards', 'initials', initials))
            .thenAnswer((_) async {
          return [
            DbEntityRecord(
              id: '',
              data: const {
                'initials': initials,
              },
            ),
          ];
        });

        final result =
            await leaderboardRepository.isInitialsAvailable(initials);

        expect(result, isFalse);
      });
    });

    group('addInitialsToScoreCard', () {
      test('adds initials to score card', () async {
        const scoreCardId = 'scoreCardId';
        const initials = 'AAA';

        when(
          () => dbClient.update(
            'score_cards',
            DbEntityRecord(
              id: scoreCardId,
              data: const {
                'initials': initials,
              },
            ),
          ),
        ).thenAnswer((_) async {});

        await leaderboardRepository.addInitialsToScoreCard(
          scoreCardId: scoreCardId,
          initials: initials,
        );

        verify(
          () => dbClient.update(
            'score_cards',
            DbEntityRecord(
              id: scoreCardId,
              data: const {
                'initials': initials,
              },
            ),
          ),
        ).called(1);
      });
    });
  });
}
