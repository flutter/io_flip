import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prompt.g.dart';

/// {@template prompt}
/// A model that contains the 3 prompt attributes required to generate a deck.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class Prompt extends Equatable {
  /// {@macro prompt}
  const Prompt({this.character, this.power, this.environment});

  /// {@macro prompt}
  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);

  /// character.
  @JsonKey()
  final String? character;

  /// power
  @JsonKey()
  final String? power;

  /// environment
  @JsonKey()
  final String? environment;

  /// Returns a copy of the instance and
  /// sets the new [attribute] to the first null in this order:
  /// [character], [power], [environment]
  Prompt copyWithNewAttribute(String attribute) {
    return Prompt(
      character: character ?? attribute,
      power: character != null ? power ?? attribute : null,
      environment: power != null ? environment ?? attribute : null,
    );
  }

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$PromptToJson(this);

  @override
  List<Object?> get props => [character, power, environment];
}
