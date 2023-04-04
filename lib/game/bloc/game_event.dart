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

class ManagePlayerPresence extends GameEvent {
  const ManagePlayerPresence(this.matchId);

  final String matchId;

  @override
  List<Object> get props => [matchId];
}

class ScoreCardUpdated extends GameEvent {
  const ScoreCardUpdated(this.updatedScore);

  final ScoreCard updatedScore;

  @override
  List<Object?> get props => [updatedScore];
}

class TurnTimerStarted extends GameEvent {
  const TurnTimerStarted();

  @override
  List<Object?> get props => [];
}

class TurnTimerTicked extends GameEvent {
  const TurnTimerTicked(this.timer);

  final Timer timer;

  @override
  List<Object?> get props => [timer];
}

class TurnAnimationsFinished extends GameEvent {
  const TurnAnimationsFinished();

  @override
  List<Object?> get props => [];
}
