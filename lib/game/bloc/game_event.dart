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

class LeaderboardEntryRequested extends GameEvent {
  const LeaderboardEntryRequested({this.shareHandPageData});
  final ShareHandPageData? shareHandPageData;

  @override
  List<Object?> get props => [shareHandPageData];
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

class ClashSceneCompleted extends GameEvent {
  const ClashSceneCompleted();

  @override
  List<Object?> get props => [];
}

class ClashSceneStarted extends GameEvent {
  const ClashSceneStarted();

  @override
  List<Object?> get props => [];
}

class TurnAnimationsFinished extends GameEvent {
  const TurnAnimationsFinished();

  @override
  List<Object?> get props => [];
}

class CardLandingStarted extends GameEvent {
  const CardLandingStarted();

  @override
  List<Object?> get props => [];
}

class CardLandingCompleted extends GameEvent {
  const CardLandingCompleted();

  @override
  List<Object?> get props => [];
}
