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
    required this.userId,
    required this.cards,
    this.shareImage,
  });

  /// {@macro deck}
  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

  /// Deck id.
  @JsonKey()
  final String id;

  /// User id.
  @JsonKey()
  final String userId;

  /// Card list.
  @JsonKey()
  final List<Card> cards;

  /// Share image.
  @JsonKey()
  final String? shareImage;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$DeckToJson(this);

  /// Returns a copy of this instance with the new [shareImage].
  Deck copyWithShareImage(String? shareImage) => Deck(
        id: id,
        userId: userId,
        cards: cards,
        shareImage: shareImage,
      );

  @override
  List<Object?> get props => [id, cards, userId, shareImage];
}
