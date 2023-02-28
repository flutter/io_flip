part of 'draft_bloc.dart';

abstract class DraftEvent extends Equatable {
  const DraftEvent();
}

class DeckRequested extends DraftEvent {
  const DeckRequested();

  @override
  List<Object> get props => [];
}

class NextCard extends DraftEvent {
  const NextCard();

  @override
  List<Object> get props => [];
}

class SelectCard extends DraftEvent {
  const SelectCard();

  @override
  List<Object> get props => [];
}
