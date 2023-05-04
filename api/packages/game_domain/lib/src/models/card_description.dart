import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_description.g.dart';

/// {@template card_description}
/// Card description.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class CardDescription extends Equatable {
  /// {@macro card_description}
  const CardDescription({
    required this.character,
    required this.characterClass,
    required this.power,
    required this.location,
    required this.description,
  });

  /// {@macro card_description}
  factory CardDescription.fromJson(Map<String, dynamic> json) =>
      _$CardDescriptionFromJson(json);

  /// Character.
  @JsonKey()
  final String character;

  /// Character class.
  @JsonKey()
  final String characterClass;

  /// Power.
  @JsonKey()
  final String power;

  /// Location.
  @JsonKey()
  final String location;

  /// Description.
  @JsonKey()
  final String description;

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => _$CardDescriptionToJson(this);

  @override
  List<Object?> get props => [
        character,
        characterClass,
        power,
        location,
        description,
      ];
}
