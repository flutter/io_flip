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
    required this.firstCardOpacity,
  });

  const DraftState.initial()
      : this(
          cards: const [],
          selectedCards: const [null, null, null],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        );

  final List<Card> cards;
  final List<Card?> selectedCards;
  final DraftStateStatus status;
  final double firstCardOpacity;

  DraftState copyWith({
    List<Card>? cards,
    List<Card?>? selectedCards,
    DraftStateStatus? status,
    double? firstCardOpacity,
  }) {
    return DraftState(
      cards: cards ?? this.cards,
      selectedCards: selectedCards ?? this.selectedCards,
      status: status ?? this.status,
      firstCardOpacity: firstCardOpacity ?? this.firstCardOpacity,
    );
  }

  @override
  List<Object> get props => [cards, status, selectedCards, firstCardOpacity];
}
