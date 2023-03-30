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

  @override
  List<Object?> get props => [playerCardId, opponentCardId];
}

class MatchLoadedState extends GameState {
  const MatchLoadedState({
    required this.match,
    required this.matchState,
    required this.turns,
    required this.playerPlayed,
    required this.playerScoreCard,
    required this.turnTimeRemaining,
  });

  final Match match;
  final MatchState matchState;
  final List<MatchTurn> turns;
  final bool playerPlayed;
  final ScoreCard playerScoreCard;
  final int turnTimeRemaining;

  MatchLoadedState copyWith({
    Match? match,
    MatchState? matchState,
    List<MatchTurn>? turns,
    bool? playerPlayed,
    ScoreCard? playerScoreCard,
    int? turnTimeRemaining,
  }) {
    return MatchLoadedState(
      match: match ?? this.match,
      matchState: matchState ?? this.matchState,
      turns: turns ?? this.turns,
      playerPlayed: playerPlayed ?? this.playerPlayed,
      playerScoreCard: playerScoreCard ?? this.playerScoreCard,
      turnTimeRemaining: turnTimeRemaining ?? this.turnTimeRemaining,
    );
  }

  @override
  List<Object> get props => [
        match,
        matchState,
        turns,
        playerPlayed,
        playerScoreCard,
        turnTimeRemaining,
      ];
}

class OpponentAbsentState extends GameState {
  const OpponentAbsentState();

  @override
  List<Object> get props => [];
}

class ManagePlayerPresenceFailedState extends GameState {
  const ManagePlayerPresenceFailedState();

  @override
  List<Object> get props => [];
}
