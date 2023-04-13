import 'dart:async';
import 'dart:math' as math;

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameResource gameResource,
    required MatchMakerRepository matchMakerRepository,
    required AudioController audioController,
    required MatchSolver matchSolver,
    required User user,
    required this.isHost,
    required ConnectionRepository connectionRepository,
  })  : _gameResource = gameResource,
        _matchMakerRepository = matchMakerRepository,
        _connectionRepository = connectionRepository,
        _audioController = audioController,
        _matchSolver = matchSolver,
        _user = user,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
    on<PlayerPlayed>(_onPlayerPlayed);
    on<MatchStateUpdated>(_onMatchStateUpdated);
    on<ScoreCardUpdated>(_onScoreCardUpdated);
    on<LeaderboardEntryRequested>(_onLeaderboardEntryRequested);
    on<ManagePlayerPresence>(_onManagePlayerPresence);
    on<TurnTimerStarted>(_onTurnTimerStarted);
    on<TurnTimerTicked>(_onTurnTimerTicked);
    on<TurnAnimationsFinished>(_onTurnAnimationsFinished);
    on<CardOverlayRevealed>(_onCardOverlayRevealed);
  }

  final GameResource _gameResource;
  final MatchMakerRepository _matchMakerRepository;
  final MatchSolver _matchSolver;
  final User _user;
  final bool isHost;
  final AudioController _audioController;
  final ConnectionRepository _connectionRepository;
  final List<String> playedCardsInOrder = [];
  Timer? _turnTimer;

  // Added to easily toggle timer functionality for testing purposes.
  static const _turnTimerEnabled = true;
  static const _turnMaxTime = 10;

  StreamSubscription<MatchState>? _stateSubscription;
  StreamSubscription<DraftMatch>? _opponentDisconnectSubscription;
  StreamSubscription<ScoreCard>? _scoreSubscription;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const MatchLoadingState());

      final values = await Future.wait([
        _gameResource.getMatch(event.matchId),
        _gameResource.getMatchState(event.matchId),
        _matchMakerRepository.getScoreCard(_user.id),
      ]);

      final match = values.first as Match?;
      final matchState = values[1] as MatchState?;
      final scoreCard = values.last as ScoreCard?;

      if (match == null || matchState == null || scoreCard == null) {
        emit(const MatchLoadFailedState());
      } else {
        _audioController.playSfx(Assets.sfx.startGame);
        emit(
          MatchLoadedState(
            match: match,
            matchState: matchState,
            rounds: const [],
            playerScoreCard: scoreCard,
            turnTimeRemaining: _turnMaxTime,
            turnAnimationsFinished: true,
          ),
        );

        final stateStream =
            _matchMakerRepository.watchMatchState(matchState.id);
        _stateSubscription = stateStream.listen((state) {
          add(MatchStateUpdated(state));
        });

        final scoreStream = _matchMakerRepository.watchScoreCard(scoreCard.id);
        _scoreSubscription = scoreStream.listen((state) {
          add(ScoreCardUpdated(state));
        });

        add(ManagePlayerPresence(event.matchId));
      }
    } catch (e, s) {
      addError(e, s);
      emit(const MatchLoadFailedState());
    }
  }

  Future<void> _onMatchStateUpdated(
    MatchStateUpdated event,
    Emitter<GameState> emit,
  ) async {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;

      final matchStatePlayerMoves = isHost
          ? event.updatedState.hostPlayedCards
          : event.updatedState.guestPlayedCards;

      final matchStateOpponentMoves = isHost
          ? event.updatedState.guestPlayedCards
          : event.updatedState.hostPlayedCards;

      String? lastPlayedCard;
      for (final cardId in [
        ...matchStatePlayerMoves,
        ...matchStateOpponentMoves
      ]) {
        if (!playedCardsInOrder.contains(cardId)) {
          playedCardsInOrder.add(cardId);
          lastPlayedCard = cardId;
        }
      }

      final moveLength = math.max(
        matchStatePlayerMoves.length,
        matchStateOpponentMoves.length,
      );

      final rounds = [
        for (var i = 0; i < moveLength; i++)
          MatchRound(
            playerCardId: i < matchStatePlayerMoves.length
                ? matchStatePlayerMoves[i]
                : null,
            opponentCardId: i < matchStateOpponentMoves.length
                ? matchStateOpponentMoves[i]
                : null,
            showCardsOverlay: i < matchLoadedState.rounds.length &&
                matchLoadedState.rounds[i].showCardsOverlay,
          ),
      ];

      if (lastPlayedCard != null) {
        _audioController.playSfx(Assets.sfx.playCard);
      }
      emit(
        matchLoadedState.copyWith(
          matchState: event.updatedState,
          rounds: rounds,
          lastPlayedCardId: lastPlayedCard,
        ),
      );

      if (_turnTimerEnabled) {
        add(const TurnTimerStarted());
      }
    }
  }

  Future<void> _onScoreCardUpdated(
    ScoreCardUpdated event,
    Emitter<GameState> emit,
  ) async {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;

      emit(
        matchLoadedState.copyWith(playerScoreCard: event.updatedScore),
      );
    }
  }

  Future<void> _onPlayerPlayed(
    PlayerPlayed event,
    Emitter<GameState> emit,
  ) async {
    if (state is MatchLoadedState) {
      final matchState = state as MatchLoadedState;
      emit(
        matchState.copyWith(
          turnAnimationsFinished: false,
        ),
      );

      _turnTimer?.cancel();

      final deckId =
          isHost ? matchState.match.hostDeck.id : matchState.match.guestDeck.id;

      await _gameResource.playCard(
        matchId: matchState.match.id,
        cardId: event.cardId,
        deckId: deckId,
      );
    }
  }

  Future<void> _onManagePlayerPresence(
    ManagePlayerPresence event,
    Emitter<GameState> emit,
  ) async {
    try {
      final completer = Completer<void>();

      final opponentDisconnectStream =
          _matchMakerRepository.watchMatch(event.matchId).where(
                (match) => isHost
                    ? match.guestConnected == false
                    : match.hostConnected == false,
              );
      _opponentDisconnectSubscription =
          opponentDisconnectStream.listen((match) async {
        final matchState = await _gameResource.getMatchState(match.id);
        final matchOver = matchState?.isOver();
        if (matchOver != true) {
          emit(const OpponentAbsentState());
        }
        completer.complete();
      });

      return completer.future;
    } catch (e, s) {
      addError(e, s);
      emit(const ManagePlayerPresenceFailedState());
    }
  }

  void _onLeaderboardEntryRequested(
    LeaderboardEntryRequested event,
    Emitter<GameState> emit,
  ) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      emit(LeaderboardEntryState(matchLoadedState.playerScoreCard.id));
    }
  }

  void _onTurnTimerStarted(
    TurnTimerStarted event,
    Emitter<GameState> emit,
  ) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      if (isPlayerAllowedToPlay &&
          !matchLoadedState.matchState.isOver() &&
          matchLoadedState.matchState.hostPlayedCards.length ==
              matchLoadedState.matchState.guestPlayedCards.length) {
        emit(matchLoadedState.copyWith(turnTimeRemaining: _turnMaxTime));

        _turnTimer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            if (!isClosed) {
              add(TurnTimerTicked(timer));
            }
          },
        );
      }
    }
  }

  void _onTurnTimerEnds() {
    if (state is MatchLoadedState) {
      final matchState = state as MatchLoadedState;

      _turnTimer?.cancel();

      final playedCards = isHost
          ? matchState.matchState.hostPlayedCards
          : matchState.matchState.guestPlayedCards;

      final cards = isHost
          ? matchState.match.hostDeck.cards.map((e) => e.id).toList()
          : matchState.match.guestDeck.cards.map((e) => e.id).toList()
        ..removeWhere(playedCards.contains);

      if (cards.isNotEmpty) {
        add(PlayerPlayed(cards.first));
      }
    }
  }

  void _onTurnTimerTicked(
    TurnTimerTicked event,
    Emitter<GameState> emit,
  ) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      final timeRemaining = matchLoadedState.turnTimeRemaining - 1;
      if (timeRemaining == 0) {
        event.timer.cancel();
        _onTurnTimerEnds();
      } else {
        emit(
          matchLoadedState.copyWith(
            turnTimeRemaining: timeRemaining,
          ),
        );
      }
    }
  }

  void _onTurnAnimationsFinished(
    TurnAnimationsFinished event,
    Emitter<GameState> emit,
  ) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      emit(matchLoadedState.copyWith(turnAnimationsFinished: true));
    }
  }

  void _onCardOverlayRevealed(
    CardOverlayRevealed event,
    Emitter<GameState> emit,
  ) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      if (matchLoadedState.rounds.isNotEmpty) {
        final lastRound = matchLoadedState.rounds.last;
        final rounds = [...matchLoadedState.rounds]
          ..removeLast()
          ..add(lastRound.copyWith(showCardsOverlay: true));
        emit(matchLoadedState.copyWith(rounds: rounds));
      }
    }
  }

  CardOverlayType? isWinningCard(Card card, {required bool isPlayer}) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      final matchState = matchLoadedState.matchState;

      final playerCards =
          isHost ? matchState.hostPlayedCards : matchState.guestPlayedCards;
      final opponentCards =
          isHost ? matchState.guestPlayedCards : matchState.hostPlayedCards;

      final round = (isPlayer ? playerCards : opponentCards)
          .indexWhere((id) => id == card.id);

      if (round >= 0) {
        final turn = matchLoadedState.rounds[round];
        if (turn.isComplete() && turn.showCardsOverlay) {
          final result = _matchSolver.calculateRoundResult(
            matchLoadedState.match,
            matchLoadedState.matchState,
            round,
          );

          if (result == MatchResult.draw) {
            return CardOverlayType.draw;
          }

          final playerWins = isHost ? MatchResult.host : MatchResult.guest;
          final opponentWins = isHost ? MatchResult.guest : MatchResult.host;

          final cardWins =
              isPlayer ? result == playerWins : result == opponentWins;

          return cardWins ? CardOverlayType.win : CardOverlayType.lose;
        }
      }
    }

    return null;
  }

  bool get isPlayerAllowedToPlay {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      return _matchSolver.isPlayerAllowedToPlay(
        matchLoadedState.matchState,
        isHost: isHost,
      );
    }
    return false;
  }

  bool canPlayerPlay(String cardId) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      return _matchSolver.canPlayCard(
        matchLoadedState.matchState,
        cardId,
        isHost: isHost,
      );
    }

    return false;
  }

  bool hasPlayerWon() {
    if (state is MatchLoadedState) {
      final matchState = (state as MatchLoadedState).matchState;

      return isHost
          ? matchState.result == MatchResult.host
          : matchState.result == MatchResult.guest;
    }
    return false;
  }

  List<Card> get playerCards {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      return isHost
          ? matchLoadedState.match.hostDeck.cards
          : matchLoadedState.match.guestDeck.cards;
    }
    return [];
  }

  List<Card> get opponentCards {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      return isHost
          ? matchLoadedState.match.guestDeck.cards
          : matchLoadedState.match.hostDeck.cards;
    }
    return [];
  }

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    _opponentDisconnectSubscription?.cancel();
    _scoreSubscription?.cancel();
    _connectionRepository.send(const WebSocketMessage.matchLeft());
    _turnTimer?.cancel();
    return super.close();
  }
}

extension MatchTurnX on MatchRound {
  bool isComplete() {
    return playerCardId != null && opponentCardId != null;
  }
}

extension MatchLoadedStateX on MatchLoadedState {
  bool isCardTurnComplete(Card card) {
    for (final turn in rounds) {
      if (card.id == turn.playerCardId || card.id == turn.opponentCardId) {
        return turn.isComplete();
      }
    }

    return false;
  }
}
