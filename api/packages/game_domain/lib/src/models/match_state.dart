import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'match_state.g.dart';

/// {@template match_state}
/// A model that represents the state of a match.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class MatchState extends Equatable {
  /// {@template match_state}
  const MatchState({
    required this.id,
    required this.matchId,
    required this.hostPlayedCards,
    required this.guestPlayedCards,
  });

  /// {@template match_state}
  factory MatchState.fromJson(Map<String, dynamic> json) =>
      _$MatchStateFromJson(json);

  /// Match State id;
  @JsonKey()
  final String id;

  /// Id of the match that this state is tied to.
  @JsonKey()
  final String matchId;

  /// List of cards played by the host
  @JsonKey()
  final List<String> hostPlayedCards;

  /// List of cards played by the guest.
  @JsonKey()
  final List<String> guestPlayedCards;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$MatchStateToJson(this);

  @override
  List<Object> get props => [
        id,
        matchId,
        hostPlayedCards,
        guestPlayedCards,
      ];
}
