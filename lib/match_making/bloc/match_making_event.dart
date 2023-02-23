part of 'match_making_bloc.dart';

abstract class MatchMakingEvent extends Equatable {
  const MatchMakingEvent();
}

class MatchRequested extends MatchMakingEvent {
  const MatchRequested();

  @override
  List<Object> get props => [];
}
