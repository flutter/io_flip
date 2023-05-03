import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prompt.g.dart';

/// {@template prompt}
/// A model that contains the 3 prompt attributes required to generate a deck.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class Prompt extends Equatable {
  /// {@macro prompt}
  const Prompt({
    this.isIntroSeen,
    this.characterClass,
    this.power,
  });

  /// {@macro prompt}
  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);

  /// Whether the prompt building intro has been seen.
  final bool? isIntroSeen;

  /// Character class.
  @JsonKey()
  final String? characterClass;

  /// Primary power.
  @JsonKey()
  final String? power;

  /// Returns a copy of the instance setting the [isIntroSeen] to true.
  Prompt setIntroSeen() {
    return Prompt(
      isIntroSeen: true,
      characterClass: characterClass,
      power: power,
    );
  }

  /// Returns a copy of the instance and
  /// sets the new [attribute] to the first null in this order:
  /// [characterClass], [power]
  Prompt copyWithNewAttribute(String attribute) {
    return Prompt(
      isIntroSeen: isIntroSeen,
      characterClass: characterClass ?? attribute,
      power: characterClass != null ? power ?? attribute : null,
    );
  }

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$PromptToJson(this);

  @override
  List<Object?> get props => [
        isIntroSeen,
        characterClass,
        power,
      ];
}
