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
      currentDeck: 'deckId',
      longestStreakDeck: 'longestId',
      initials: 'initials',
    );

    test('fromJson returns the correct instance', () {
      expect(
        ScoreCard.fromJson(const {
          'id': 'id',
          'wins': 1,
          'longestStreak': 1,
          'currentStreak': 1,
          'currentDeck': 'deckId',
          'longestStreakDeck': 'longestId',
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

      expect(
        ScoreCard(
          id: '',
          wins: 1,
          currentStreak: 1,
          longestStreak: 1,
          currentDeck: 'deckId',
          longestStreakDeck: 'longestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
      expect(
        ScoreCard(
          id: 'id',
          wins: 2,
          currentStreak: 1,
          longestStreak: 1,
          currentDeck: 'deckId',
          longestStreakDeck: 'longestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          currentStreak: 2,
          longestStreak: 1,
          currentDeck: 'deckId',
          longestStreakDeck: 'longestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          currentStreak: 1,
          longestStreak: 2,
          currentDeck: 'deckId',
          longestStreakDeck: 'longestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          currentStreak: 1,
          longestStreak: 1,
          longestStreakDeck: 'longestId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
      expect(
        ScoreCard(
          id: 'id',
          wins: 1,
          currentStreak: 1,
          longestStreak: 1,
          currentDeck: 'deckId',
          initials: 'initials',
        ),
        isNot(
          equals(scoreCard),
        ),
      );
    });
  });
}
