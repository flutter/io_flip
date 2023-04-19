part of 'prompt_form_bloc.dart';

abstract class PromptFormEvent extends Equatable {
  const PromptFormEvent();
}

class PromptTermsRequested extends PromptFormEvent {
  const PromptTermsRequested();

  @override
  List<Object?> get props => [];
}

class PromptSubmitted extends PromptFormEvent {
  const PromptSubmitted({required this.data});

  final Prompt data;

  @override
  List<Object> get props => [data];
}
