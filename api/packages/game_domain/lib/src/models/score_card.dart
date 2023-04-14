import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'score_card.g.dart';

/// {@template score_card}
/// A class representing the user session's win and streak count.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class ScoreCard extends Equatable {
  /// {@macro score_card}
  const ScoreCard({
    required this.id,
    this.wins = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.currentDeck = '',
    this.longestStreakDeck = '',
    this.initials,
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

  /// Unique identifier of the deck which was used to set the [longestStreak]
  @JsonKey()
  final String longestStreakDeck;

  /// Initials of the player.
  @JsonKey()
  final String? initials;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$ScoreCardToJson(this);

  @override
  List<Object?> get props => [
        id,
        wins,
        longestStreak,
        currentStreak,
        currentDeck,
        longestStreakDeck,
        initials,
      ];
}
