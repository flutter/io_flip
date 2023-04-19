part of 'prompt_form_bloc.dart';

enum PromptTermsStatus { initial, loading, loaded, failed }

class PromptFormState extends Equatable {
  const PromptFormState({
    required this.status,
    required this.prompts,
    this.characterClasses = const [],
    this.powers = const [],
  });

  const PromptFormState.initial()
      : this(
          status: PromptTermsStatus.initial,
          prompts: const Prompt(),
          characterClasses: const [],
          powers: const [],
        );

  final PromptTermsStatus status;
  final Prompt prompts;
  final List<String> characterClasses;
  final List<String> powers;

  PromptFormState copyWith({
    PromptTermsStatus? status,
    Prompt? prompts,
    List<String>? characterClasses,
    List<String>? powers,
  }) {
    return PromptFormState(
      status: status ?? this.status,
      prompts: prompts ?? this.prompts,
      characterClasses: characterClasses ?? this.characterClasses,
      powers: powers ?? this.powers,
    );
  }

  @override
  List<Object> get props => [status, prompts, characterClasses, powers];
}
