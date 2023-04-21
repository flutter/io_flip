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

class MatchRound extends Equatable {
  const MatchRound({
    required this.playerCardId,
    required this.opponentCardId,
    this.showCardsOverlay = false,
  });

  final String? playerCardId;
  final String? opponentCardId;
  final bool showCardsOverlay;

  MatchRound copyWith({
    String? playerCardId,
    String? opponentCardId,
    bool? showCardsOverlay,
  }) {
    return MatchRound(
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
    required this.rounds,
    required this.playerScoreCard,
    required this.turnTimeRemaining,
    required this.turnAnimationsFinished,
    this.lastPlayedCardId,
  });

  final Match match;
  final MatchState matchState;
  final List<MatchRound> rounds;
  final ScoreCard playerScoreCard;
  final int turnTimeRemaining;
  final bool turnAnimationsFinished;
  final String? lastPlayedCardId;

  MatchLoadedState copyWith({
    Match? match,
    MatchState? matchState,
    List<MatchRound>? rounds,
    ScoreCard? playerScoreCard,
    int? turnTimeRemaining,
    bool? turnAnimationsFinished,
    String? lastPlayedCardId,
  }) {
    return MatchLoadedState(
      match: match ?? this.match,
      matchState: matchState ?? this.matchState,
      rounds: rounds ?? this.rounds,
      playerScoreCard: playerScoreCard ?? this.playerScoreCard,
      turnTimeRemaining: turnTimeRemaining ?? this.turnTimeRemaining,
      turnAnimationsFinished:
          turnAnimationsFinished ?? this.turnAnimationsFinished,
      lastPlayedCardId: lastPlayedCardId,
    );
  }

  @override
  List<Object> get props => [
        match,
        matchState,
        rounds,
        playerScoreCard,
        turnTimeRemaining,
        turnAnimationsFinished,
      ];
}

class LeaderboardEntryState extends GameState {
  const LeaderboardEntryState(
    this.scoreCardId, {
    this.shareHandPageData,
  });

  final String scoreCardId;
  final ShareHandPageData? shareHandPageData;

  @override
  List<Object?> get props => [scoreCardId, shareHandPageData];
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
