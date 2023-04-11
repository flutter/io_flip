import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prompt_term.g.dart';

/// The type of the prompt term.
enum PromptTermType {
  /// Character.
  character,

  /// Character Class.
  characterClass,

  /// Primary power type.
  power,

  /// Secondary power class.
  secondaryPower,

  /// A location.
  location;
}

/// {@template prompt_term}
/// A term used as a prompt for card generation.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class PromptTerm extends Equatable {
  /// {@macro prompt_term}
  const PromptTerm({
    required this.term,
    required this.type,
    this.id,
  });

  /// Creates a [PromptTerm] from a JSON object.
  factory PromptTerm.fromJson(Map<String, dynamic> json) =>
      _$PromptTermFromJson(json);

  @JsonKey()

  /// The id of the prompt term.
  final String? id;

  @JsonKey()

  /// The term of the prompt term.
  final String term;

  @JsonKey()

  /// The type of the prompt term.
  final PromptTermType type;

  /// Converts a [PromptTerm] to a JSON object.
  Map<String, dynamic> toJson() => _$PromptTermToJson(this);

  @override
  List<Object?> get props => [id, term, type];
}
