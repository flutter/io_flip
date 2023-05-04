part of 'draft_bloc.dart';

enum DraftStateStatus {
  initial,
  deckLoading,
  deckLoaded,
  deckFailed,
  deckSelected,
  playerDeckCreated,
  playerDeckFailed,
}

class DraftState extends Equatable {
  const DraftState({
    required this.cards,
    required this.status,
    required this.selectedCards,
    required this.firstCardOpacity,
    this.deck,
    this.createPrivateMatch,
    this.privateMatchInviteCode,
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
  final Deck? deck;
  final bool? createPrivateMatch;
  final String? privateMatchInviteCode;

  DraftState copyWith({
    List<Card>? cards,
    List<Card?>? selectedCards,
    DraftStateStatus? status,
    double? firstCardOpacity,
    Deck? deck,
    bool? createPrivateMatch,
    String? privateMatchInviteCode,
  }) {
    return DraftState(
      cards: cards ?? this.cards,
      selectedCards: selectedCards ?? this.selectedCards,
      status: status ?? this.status,
      firstCardOpacity: firstCardOpacity ?? this.firstCardOpacity,
      deck: deck ?? this.deck,
      createPrivateMatch: createPrivateMatch ?? this.createPrivateMatch,
      privateMatchInviteCode:
          privateMatchInviteCode ?? this.privateMatchInviteCode,
    );
  }

  @override
  List<Object?> get props =>
      [cards, status, selectedCards, firstCardOpacity, deck];
}
