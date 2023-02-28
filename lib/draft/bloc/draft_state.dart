part of 'draft_bloc.dart';

enum DraftStateStatus {
  initial,
  deckLoading,
  deckLoaded,
  deckFailed,
  deckSelected,
}

class DraftState extends Equatable {
  const DraftState({
    required this.cards,
    required this.status,
    required this.selectedCards,
  });

  const DraftState.initial()
      : this(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
        );

  final List<Card> cards;
  final List<Card> selectedCards;
  final DraftStateStatus status;

  DraftState copyWith({
    List<Card>? cards,
    List<Card>? selectedCards,
    DraftStateStatus? status,
  }) {
    return DraftState(
      cards: cards ?? this.cards,
      selectedCards: selectedCards ?? this.selectedCards,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [cards, status, selectedCards];
}
