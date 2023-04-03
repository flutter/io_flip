import 'dart:async';
import 'dart:math' as math;

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart' as repo;
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameResource gameResource,
    required repo.MatchMakerRepository matchMakerRepository,
    required MatchSolver matchSolver,
    required User user,
    required this.isHost,
    required this.matchConnection,
  })  : _gameResource = gameResource,
        _matchMakerRepository = matchMakerRepository,
        _matchSolver = matchSolver,
        _user = user,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
    on<PlayerPlayed>(_onPlayerPlayed);
    on<MatchStateUpdated>(_onMatchStateUpdated);
    on<ScoreCardUpdated>(_onScoreCardUpdated);
    on<ManagePlayerPresence>(_onManagePlayerPresence);
    on<TurnTimerStarted>(_onTurnTimerStarted);
    on<TurnTimerTicked>(_onTurnTimerTicked);
  }

  final GameResource _gameResource;
  final repo.MatchMakerRepository _matchMakerRepository;
  final MatchSolver _matchSolver;
  final User _user;
  final bool isHost;
  final WebSocket? matchConnection;
  Timer? _turnTimer;

  // Added to easily toggle timer functionality for testing purposes.
  static const _turnTimerEnabled = true;
  static const _turnMaxTime = 10;

  StreamSubscription<MatchState>? _stateSubscription;
  StreamSubscription<repo.Match>? _opponentDisconnectSubscription;
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
        emit(
          MatchLoadedState(
            match: match,
            matchState: matchState,
            turns: const [],
            playerPlayed: false,
            playerScoreCard: scoreCard,
            turnTimeRemaining: _turnMaxTime,
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

      final isPlayerMove = matchLoadedState.turns
              .where((turn) => turn.playerCardId != null)
              .length !=
          matchStatePlayerMoves.length;

      final moveLength = math.max(
        matchStatePlayerMoves.length,
        matchStateOpponentMoves.length,
      );

      final turns = [
        for (var i = 0; i < moveLength; i++)
          MatchTurn(
            playerCardId: i < matchStatePlayerMoves.length
                ? matchStatePlayerMoves[i]
                : null,
            opponentCardId: i < matchStateOpponentMoves.length
                ? matchStateOpponentMoves[i]
                : null,
          ),
      ];

      emit(
        matchLoadedState.copyWith(
          matchState: event.updatedState,
          turns: turns,
          playerPlayed: isPlayerMove ? false : null,
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
      emit(matchState.copyWith(playerPlayed: true));

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

  void _onTurnTimerStarted(
    TurnTimerStarted event,
    Emitter<GameState> emit,
  ) {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      if (isPlayerTurn && !matchLoadedState.matchState.isOver()) {
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
        final turn = matchLoadedState.turns[round];
        if (turn.isComplete()) {
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

  bool get isPlayerTurn {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      return _matchSolver.isPlayerTurn(
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

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    _opponentDisconnectSubscription?.cancel();
    _scoreSubscription?.cancel();
    matchConnection?.close();
    _turnTimer?.cancel();
    return super.close();
  }
}

extension MatchTurnX on MatchTurn {
  bool isComplete() {
    return playerCardId != null && opponentCardId != null;
  }
}

extension MatchLoadedStateX on MatchLoadedState {
  bool isCardTurnComplete(Card card) {
    for (final turn in turns) {
      if (card.id == turn.playerCardId || card.id == turn.opponentCardId) {
        return turn.isComplete();
      }
    }

    return false;
  }
}
