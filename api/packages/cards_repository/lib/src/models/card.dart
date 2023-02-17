import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

/// {@template card}
/// Model representing a card.
/// {@endtemplate}
@JsonSerializable(createFactory: false)
class Card extends Equatable {
  /// {@macro card}
  const Card({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.product,
    required this.design,
    required this.frontend,
    required this.backend,
    required this.rarity,
  });

  /// Id
  final String id;

  /// Name
  final String name;

  /// Description
  final String description;

  /// Image
  final String image;

  /// Product
  final int product;

  /// Design
  final int design;

  /// Frontend
  final int frontend;

  /// Backend
  final int backend;

  /// Rarity
  final bool rarity;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$CardToJson(this);

  @override
  List<Object> get props => [
        id,
        name,
        description,
        image,
        product,
        design,
        frontend,
        backend,
        rarity,
      ];
}
