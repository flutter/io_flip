import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardResults', () {
    test('supports value equality', () {
      const scoreCardOne = ScoreCard(
        id: 'id',
        wins: 2,
        currentStreak: 2,
        longestStreak: 3,
        longestStreakDeck: 'deckId',
      );
      const scoreCardTwo = ScoreCard(
        id: 'id2',
        wins: 3,
        currentStreak: 3,
        longestStreak: 4,
        longestStreakDeck: 'deckId2',
      );

      const leaderboardResultsA = LeaderboardResults(
        scoreCardsWithMostWins: [scoreCardOne],
        scoreCardsWithLongestStreak: [scoreCardOne],
      );
      const secondLeaderboardResultsA = LeaderboardResults(
        scoreCardsWithMostWins: [scoreCardOne],
        scoreCardsWithLongestStreak: [scoreCardOne],
      );
      const leaderboardResultsB = LeaderboardResults(
        scoreCardsWithMostWins: [scoreCardTwo],
        scoreCardsWithLongestStreak: [scoreCardTwo],
      );

      expect(leaderboardResultsA, equals(secondLeaderboardResultsA));
      expect(leaderboardResultsA, isNot(equals(leaderboardResultsB)));
    });
  });
}
