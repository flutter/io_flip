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

  @override
  List<Object?> get props => [id, wins, longestStreak, currentStreak];
}
