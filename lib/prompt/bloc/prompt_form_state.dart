part of 'prompt_form_bloc.dart';

class PromptFormState extends Equatable {
  const PromptFormState({
    this.prompts = const FlowData(),
  });

  final FlowData prompts;

  PromptFormState copyWith({
    FlowData? prompts,
  }) {
    return PromptFormState(
      prompts: prompts ?? this.prompts,
    );
  }

  @override
  List<Object> get props => [prompts];
}
