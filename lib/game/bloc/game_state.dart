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
  const MatchLoadFailedState({required this.deck});

  final Deck? deck;

  @override
  List<Object?> get props => [deck];
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
    required this.isClashScene,
    required this.showCardLanding,
    this.lastPlayedCardId,
  });

  final Match match;
  final MatchState matchState;
  final List<MatchRound> rounds;
  final ScoreCard playerScoreCard;
  final int turnTimeRemaining;
  final bool turnAnimationsFinished;
  final bool isClashScene;
  final bool showCardLanding;
  final String? lastPlayedCardId;

  MatchLoadedState copyWith({
    Match? match,
    MatchState? matchState,
    List<MatchRound>? rounds,
    ScoreCard? playerScoreCard,
    int? turnTimeRemaining,
    bool? turnAnimationsFinished,
    bool? isClashScene,
    bool? showCardLanding,
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
      isClashScene: isClashScene ?? this.isClashScene,
      showCardLanding: showCardLanding ?? this.showCardLanding,
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
        isClashScene,
        showCardLanding,
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
  const OpponentAbsentState({required this.deck});

  final Deck? deck;

  @override
  List<Object?> get props => [deck];
}

class ManagePlayerPresenceFailedState extends GameState {
  const ManagePlayerPresenceFailedState();

  @override
  List<Object> get props => [];
}
