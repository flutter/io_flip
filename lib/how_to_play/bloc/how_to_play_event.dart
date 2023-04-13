part of 'how_to_play_bloc.dart';

abstract class HowToPlayEvent extends Equatable {
  const HowToPlayEvent();

  @override
  List<Object> get props => [];
}

class NextPageRequested extends HowToPlayEvent {
  const NextPageRequested();
}

class PreviousPageRequested extends HowToPlayEvent {
  const PreviousPageRequested();
}
