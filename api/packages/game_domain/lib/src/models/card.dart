import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

/// Represents the suit or family of card.
enum Suit {
  /// Represents the suit of fire.
  fire,

  /// Represents the suit of air.
  air,

  /// Represents the suit of earth.
  earth,

  /// Represents the suit of metal.
  metal,

  /// Represents the suit of water.
  water,
}

/// {@template card}
/// Model representing a card.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class Card extends Equatable {
  /// {@macro card}
  const Card({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.power,
    required this.rarity,
    required this.suit,
  });

  /// {@macro card}
  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  /// Id
  @JsonKey()
  final String id;

  /// Name
  @JsonKey()
  final String name;

  /// Description
  @JsonKey()
  final String description;

  /// Image
  @JsonKey()
  final String image;

  /// Product
  @JsonKey()
  final int power;

  /// Rarity
  @JsonKey()
  final bool rarity;

  /// Suit
  @JsonKey()
  final Suit suit;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$CardToJson(this);

  @override
  List<Object> get props => [
        id,
        name,
        description,
        image,
        power,
        rarity,
        suit,
      ];
}
