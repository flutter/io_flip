import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_player.g.dart';

/// {@template leaderboard_player}
/// A model that represents a player in the leaderboard.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class LeaderboardPlayer extends Equatable {
  /// {@macro leaderboard_player}
  const LeaderboardPlayer({
    required this.id,
    required this.longestStreak,
    required this.initials,
  });

  /// {@macro leaderboard_player}
  factory LeaderboardPlayer.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardPlayerFromJson(json);

  /// Unique identifier of the leaderboard player object
  /// and session id for the player.
  @JsonKey()
  final String id;

  /// Longest streak of wins in the session.
  @JsonKey()
  final int longestStreak;

  /// Initials of the player.
  @JsonKey()
  final String initials;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$LeaderboardPlayerToJson(this);

  @override
  List<Object?> get props => [id, longestStreak, initials];
}
