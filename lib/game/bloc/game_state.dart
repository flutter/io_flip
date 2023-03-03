part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();
}

class MatchLoadingState extends GameState {
  const MatchLoadingState();

  @override
  List<Object> get props => [];
}

class MatchLoadFailedState extends GameState {
  const MatchLoadFailedState();

  @override
  List<Object> get props => [];
}

class MatchLoadedState extends GameState {
  const MatchLoadedState({
    required this.match, 
    required this.matchState, 
  });

  final Match match;
  final MatchState matchState;

  @override
  List<Object> get props => [match, matchState];
}
