// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('ScoreCard', () {
    test('can be instantiated', () {
      expect(
        ScoreCard(
          id: '',
        ),
        isNotNull,
      );
    });
    final scoreCard = ScoreCard(
      id: 'id',
      wins: 1,
      longestStreak: 1,
      currentStreak: 1,
      latestStreak: 1,
      longestStreakDeck: 'longestId',
      currentDeck: 'deckId',
      latestDeck: 'latestId',
      initials: 'initials',
    );

    test('toJson returns the instance as json', () {
      expect(
        scoreCard.toJson(),
        equals({
          'id': 'id',
          'wins': 1,
          'longestStreak': 1,
          'currentStreak': 1,
          'latestStreak': 1,
          'longestStreakDeck': 'longestId',
          'currentDeck': 'deckId',
          'latestDeck': 'latestId',
          'initials': 'initials',
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        ScoreCard.fromJson(const {
          'id': 'id',
          'wins': 1,
          'longestStreak': 1,
          'currentStreak': 1,
          'latestStreak': 1,
          'longestStreakDeck': 'longestId',
          'currentDeck': 'deckId',
          'latestDeck': 'latestId',
          'initials': 'initials',
        }),
        equals(scoreCard),
      );
    });

    test('supports equality', () {
      expect(
        ScoreCard(id: ''),
        equals(ScoreCard(id: '')),
      );

      // different id
      expect(
        ScoreCard(
          id: '',
          wins: 1,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different wins
      expect(
        ScoreCard(
          id: 'id',
          wins: 2,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different longestStreak
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 2,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different currentStreak
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 1,
          currentStreak: 2,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different latestStreak
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 2,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different longestStreakDeck
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: '-',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different currentDeck
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: '-',
          latestDeck: 'latestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different latestDeck
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: '-',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );

      // different initials
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          longestStreak: 1,
          currentStreak: 1,
          latestStreak: 1,
          longestStreakDeck: 'longestId',
          currentDeck: 'deckId',
          latestDeck: 'latestId',
          initials: '-',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
    });
  });
}
