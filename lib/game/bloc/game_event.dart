part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class MatchRequested extends GameEvent {

  const MatchRequested(this.matchId);

  final String matchId;

  @override
  List<Object> get props => [matchId];
}
