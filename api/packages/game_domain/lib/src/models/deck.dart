import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deck.g.dart';

/// {@template deck}
/// A model that represents a deck of cards.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class Deck extends Equatable {
  /// {@macro deck}
  const Deck({
    required this.id,
    required this.cards,
  });

  /// {@macro deck}
  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

  /// Deck id.
  @JsonKey()
  final String id;

  /// Card list.
  @JsonKey()
  final List<Card> cards;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$DeckToJson(this);

  @override
  List<Object> get props => [id, cards];
}
