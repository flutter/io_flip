part of 'draft_bloc.dart';

enum DraftStateStatus {
  initial,
  cardLoading,
  cardLoaded,
  cardFailed,
  deckCompleted,
}

class DraftState extends Equatable {
  const DraftState({
    required this.cards,
    required this.status,
  });

  const DraftState.initial() : this(
    cards: const [],
    status: DraftStateStatus.initial,
  );

  final List<Card> cards;
  final DraftStateStatus status;

  DraftState copyWith({
    List<Card>? cards,
    DraftStateStatus? status,
  }) {
    return DraftState(
      cards: cards ?? this.cards,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [cards, status];
}
