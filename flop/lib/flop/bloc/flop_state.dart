part of 'flop_bloc.dart';

enum FlopStatus {
  running,
  success,
  error,
}

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
    this.status = FlopStatus.running,
  });

  const FlopState.initial()
      : this(
          steps: const [],
          messages: const [],
        );

  final List<FlopStep> steps;
  final List<String> messages;
  final FlopStatus status;

  FlopState copyWith({
    List<FlopStep>? steps,
    List<String>? messages,
    FlopStatus? status,
  }) {
    return FlopState(
      steps: steps ?? this.steps,
      messages: messages ?? this.messages,
      status: status ?? this.status,
    );
  }

  FlopState withNewMessage(String message) {
    return copyWith(
      messages: [message, ...messages],
    );
  }

  @override
  List<Object> get props => [steps, messages, status];
}
