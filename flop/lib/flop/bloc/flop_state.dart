part of 'flop_bloc.dart';

enum FlopStep {
  initial,
  authentication,
  deckDraft,
  matchmaking,
  joinedMatch,
  playing,
}

class FlopState extends Equatable {
  const FlopState({
    required this.steps,
    required this.messages,
  });

  const FlopState.initial()
      : this(
          steps: const [],
          messages: const [],
        );

  final List<FlopStep> steps;
  final List<String> messages;

  FlopState copyWith({
    List<FlopStep>? steps,
    List<String>? messages,
  }) {
    return FlopState(
      steps: steps ?? this.steps,
      messages: messages ?? this.messages,
    );
  }

  FlopState withNewMessage(String message) {
    return copyWith(
      messages: [message, ...messages],
    );
  }

  @override
  List<Object> get props => [steps, messages];
}
