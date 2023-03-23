import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'score_card.g.dart';

/// {@template score_card}
/// A class representing the user session's win and streak count.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, createToJson: false)
class ScoreCard extends Equatable {
  /// {@macro score_card}
  const ScoreCard({
    required this.id,
    this.wins = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.currentDeck = '',
    this.longestStreakDeck = '',
  });

  /// {@macro score_card}
  factory ScoreCard.fromJson(Map<String, dynamic> json) =>
      _$ScoreCardFromJson(json);

  /// Unique identifier of the score object and session id for the player.
  @JsonKey()
  final String id;

  /// number of wins in the session.
  @JsonKey()
  final int wins;

  /// Longest streak of wins in the session.
  @JsonKey()
  final int longestStreak;

  /// Current streak of wins in the session.
  @JsonKey()
  final int currentStreak;

  /// Unique identifier of the deck played in the session
  @JsonKey()
  final String currentDeck;

  @JsonKey()

  /// Unique identifier of the deck which was used to set the [longestStreak]
  final String longestStreakDeck;

  @override
  List<Object?> get props => [
        id,
        wins,
        longestStreak,
        currentStreak,
        currentDeck,
        longestStreakDeck,
      ];
}
