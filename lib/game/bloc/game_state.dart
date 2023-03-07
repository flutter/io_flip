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

class MatchTurn extends Equatable {
  const MatchTurn({
    required this.playerCardId,
    required this.opponentCardId,
  });

  final String? playerCardId;
  final String? opponentCardId;

  MatchTurn copyWith({
    String? playerCardId,
    String? opponentCardId,
  }) {
    return MatchTurn(
      playerCardId: playerCardId ?? this.playerCardId,
      opponentCardId: opponentCardId ?? this.opponentCardId,
    );
  }

  @override
  List<Object?> get props => [playerCardId, opponentCardId];
}

class MatchLoadedState extends GameState {
  const MatchLoadedState({
    required this.match,
    required this.matchState,
    required this.turns,
  });

  final Match match;
  final MatchState matchState;
  final List<MatchTurn> turns;

  MatchLoadedState copyWith({
    Match? match,
    MatchState? matchState,
    List<MatchTurn>? turns,
  }) {
    return MatchLoadedState(
      match: match ?? this.match,
      matchState: matchState ?? this.matchState,
      turns: turns ?? this.turns,
    );
  }

  @override
  List<Object> get props => [match, matchState, turns];
}
