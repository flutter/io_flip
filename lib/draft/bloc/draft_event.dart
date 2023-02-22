part of 'draft_bloc.dart';

abstract class DraftEvent extends Equatable {
  const DraftEvent();
}

class CardRequested extends DraftEvent {
  const CardRequested();

  @override
  List<Object> get props => [];
}
