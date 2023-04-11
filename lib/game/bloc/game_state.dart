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
    this.showCardsOverlay = false,
  });

  final String? playerCardId;
  final String? opponentCardId;
  final bool showCardsOverlay;

  MatchTurn copyWith({
    String? playerCardId,
    String? opponentCardId,
    bool? showCardsOverlay,
  }) {
    return MatchTurn(
      playerCardId: playerCardId ?? this.playerCardId,
      opponentCardId: opponentCardId ?? this.opponentCardId,
      showCardsOverlay: showCardsOverlay ?? this.showCardsOverlay,
    );
  }

  @override
  List<Object?> get props => [playerCardId, opponentCardId, showCardsOverlay];
}

class MatchLoadedState extends GameState {
  const MatchLoadedState({
    required this.match,
    required this.matchState,
    required this.turns,
    required this.playerScoreCard,
    required this.turnTimeRemaining,
    required this.turnAnimationsFinished,
  });

  final Match match;
  final MatchState matchState;
  final List<MatchTurn> turns;
  final ScoreCard playerScoreCard;
  final int turnTimeRemaining;
  final bool turnAnimationsFinished;

  MatchLoadedState copyWith({
    Match? match,
    MatchState? matchState,
    List<MatchTurn>? turns,
    bool? playerPlayed,
    ScoreCard? playerScoreCard,
    int? turnTimeRemaining,
    bool? turnAnimationsFinished,
  }) {
    return MatchLoadedState(
      match: match ?? this.match,
      matchState: matchState ?? this.matchState,
      turns: turns ?? this.turns,
      playerScoreCard: playerScoreCard ?? this.playerScoreCard,
      turnTimeRemaining: turnTimeRemaining ?? this.turnTimeRemaining,
      turnAnimationsFinished:
          turnAnimationsFinished ?? this.turnAnimationsFinished,
    );
  }

  @override
  List<Object> get props => [
        match,
        matchState,
        turns,
        playerScoreCard,
        turnTimeRemaining,
        turnAnimationsFinished,
      ];
}

class LeaderboardEntryState extends GameState {
  const LeaderboardEntryState(this.scoreCardId);

  final String scoreCardId;

  @override
  List<Object?> get props => [scoreCardId];
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
