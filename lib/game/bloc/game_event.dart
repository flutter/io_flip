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

class PlayerPlayed extends GameEvent {
  const PlayerPlayed(this.cardId);

  final String cardId;

  @override
  List<Object> get props => [cardId];
}

class MatchStateUpdated extends GameEvent {
  const MatchStateUpdated(this.updatedState);

  final MatchState updatedState;

  @override
  List<Object?> get props => [updatedState];
}

class ScoreCardUpdated extends GameEvent {
  const ScoreCardUpdated(this.updatedScore);

  final ScoreCard updatedScore;

  @override
  List<Object?> get props => [updatedScore];
}

class ManagePlayerPresence extends GameEvent {
  const ManagePlayerPresence(this.matchId);

  final String matchId;

  @override
  List<Object> get props => [matchId];
}
