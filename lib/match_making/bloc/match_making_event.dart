part of 'match_making_bloc.dart';

abstract class MatchMakingEvent extends Equatable {
  const MatchMakingEvent();
}

class MatchRequested extends MatchMakingEvent {
  const MatchRequested({this.raceConditionCounter = 0});
  final int raceConditionCounter;

  @override
  List<Object> get props => [raceConditionCounter];
}

class PrivateMatchRequested extends MatchMakingEvent {
  const PrivateMatchRequested();

  @override
  List<Object> get props => [];
}

class GuestPrivateMatchRequested extends MatchMakingEvent {
  const GuestPrivateMatchRequested(this.inviteCode);

  final String inviteCode;

  @override
  List<Object> get props => [inviteCode];
}
