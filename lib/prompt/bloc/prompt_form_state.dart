part of 'prompt_form_bloc.dart';

class PromptFormState extends Equatable {
  const PromptFormState({
    this.prompts = const Prompt(),
  });

  final Prompt prompts;

  PromptFormState copyWith({
    Prompt? prompts,
  }) {
    return PromptFormState(
      prompts: prompts ?? this.prompts,
    );
  }

  @override
  List<Object> get props => [prompts];
}
