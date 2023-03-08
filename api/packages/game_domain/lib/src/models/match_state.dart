import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'match_state.g.dart';

const _maxTurns = 3;

/// Enum listing the possibles outcomes of a match.
enum MatchResult {
  /// Host won.
  host,

  /// Guest won.
  guest,

  /// Draw.
  draw;

  /// Tries to match the string with an entry of the enum.
  ///
  /// Returns null if no match is found.
  static MatchResult? valueOf(String? value) {
    if (value != null) {
      for (final enumValue in MatchResult.values) {
        if (enumValue.name == value) {
          return enumValue;
        }
      }
    }

    return null;
  }
}

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
    this.result,
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

  /// Result of the match.
  @JsonKey()
  final MatchResult? result;

  /// Returns if the match is over.
  bool isOver() {
    return hostPlayedCards.length == _maxTurns &&
        guestPlayedCards.length == _maxTurns;
  }

  /// Copy this instance, adding the given [cardId] to the [hostPlayedCards].
  MatchState addHostPlayedCard(String cardId) {
    return MatchState(
      id: id,
      matchId: matchId,
      guestPlayedCards: guestPlayedCards,
      hostPlayedCards: [...hostPlayedCards, cardId],
      result: result,
    );
  }

  /// Copy this instance, adding the given [cardId] to the [guestPlayedCards].
  MatchState addGuestPlayedCard(String cardId) {
    return MatchState(
      id: id,
      matchId: matchId,
      guestPlayedCards: [...guestPlayedCards, cardId],
      hostPlayedCards: hostPlayedCards,
      result: result,
    );
  }

  /// Copy this instance, setting the given [result].
  MatchState setResult(MatchResult result) {
    return MatchState(
      id: id,
      matchId: matchId,
      guestPlayedCards: guestPlayedCards,
      hostPlayedCards: hostPlayedCards,
      result: result,
    );
  }

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$MatchStateToJson(this);

  @override
  List<Object?> get props => [
        id,
        matchId,
        hostPlayedCards,
        guestPlayedCards,
        result,
      ];
}
