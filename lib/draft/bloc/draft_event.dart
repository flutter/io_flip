part of 'draft_bloc.dart';

abstract class DraftEvent extends Equatable {
  const DraftEvent();
}

class DeckRequested extends DraftEvent {
  const DeckRequested();

  @override
  List<Object> get props => [];
}

class PreviousCard extends DraftEvent {
  const PreviousCard();

  @override
  List<Object> get props => [];
}

class NextCard extends DraftEvent {
  const NextCard();

  @override
  List<Object> get props => [];
}

class CardSwiped extends DraftEvent {
  const CardSwiped();

  @override
  List<Object> get props => [];
}

class CardSwipeStarted extends DraftEvent {
  const CardSwipeStarted(this.progress);

  final double progress;

  @override
  List<Object> get props => [progress];
}

class SelectCard extends DraftEvent {
  const SelectCard();

  @override
  List<Object> get props => [];
}
