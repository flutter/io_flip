part of 'draft_bloc.dart';

abstract class DraftEvent extends Equatable {
  const DraftEvent();
}

class CardRequested extends DraftEvent {
  @override
  List<Object> get props => [];
}
