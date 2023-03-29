import 'dart:async';
import 'dart:math';

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
  }

  final GameResource _gameResource;
  final repo.MatchMakerRepository _matchMakerRepository;
  final MatchSolver _matchSolver;
  final User _user;
  final bool isHost;
  final WebSocket? matchConnection;

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

      final moveLength = max(
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
          opponentDisconnectStream.listen((state) {
        emit(const OpponentAbsentState());
        completer.complete();
      });

      return completer.future;
    } catch (e, s) {
      addError(e, s);
      emit(const ManagePlayerPresenceFailedState());
    }
  }

  CardOverlayType? isWinningCard(Card card, {required bool isPlayer}) {
    if (state is MatchLoadedState) {
      final isCardFromHost = isPlayer && isHost;

      final matchLoadedState = state as MatchLoadedState;
      final matchState = matchLoadedState.matchState;

      final round = isHost
          ? matchState.hostPlayedCards.indexWhere((id) => id == card.id)
          : matchState.guestPlayedCards.indexWhere((id) => id == card.id);

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
          final cardWins = isCardFromHost
              ? result == MatchResult.host
              : result == MatchResult.guest;
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
