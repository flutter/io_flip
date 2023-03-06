import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart';

/// {@template match}
/// A model that represents a match.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class Match extends Equatable {
  /// {@macro match}
  const Match({
    required this.id,
    required this.hostDeck,
    required this.guestDeck,
  });

  /// {@macro match}
  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  /// Match id.
  @JsonKey()
  final String id;

  /// Deck of the host.
  @JsonKey()
  final Deck hostDeck;

  /// Deck of the guest.
  @JsonKey()
  final Deck guestDeck;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$MatchToJson(this);

  @override
  List<Object> get props => [id, hostDeck, guestDeck];
}
