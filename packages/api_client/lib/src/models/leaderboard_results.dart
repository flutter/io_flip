import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

/// {@template leaderboard_results}
/// Results from the leaderboard for highest win streak and highest total wins.
/// {@endtemplate}
class LeaderboardResults extends Equatable {
  /// {@macro leaderboard_results}
  const LeaderboardResults({
    this.scoreCardsWithMostWins = const [],
    this.scoreCardsWithLongestStreak = const [],
  });

  /// List of [ScoreCard]s with the most total wins.
  final List<ScoreCard> scoreCardsWithMostWins;

  /// List of [ScoreCard]s with the longest win streak.
  final List<ScoreCard> scoreCardsWithLongestStreak;

  @override
  List<Object?> get props => [
        scoreCardsWithMostWins,
        scoreCardsWithLongestStreak,
      ];
}
