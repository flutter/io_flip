part of 'prompt_form_bloc.dart';

abstract class PromptFormEvent extends Equatable {
  const PromptFormEvent();
}

class PromptSubmitted extends PromptFormEvent {
  const PromptSubmitted({required this.data});

  final FlowData data;

  @override
  List<Object> get props => [data];
}
