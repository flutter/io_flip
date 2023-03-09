import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart' hide Match;

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameClient gameClient,
    required MatchMakerRepository matchMakerRepository,
    required this.isHost,
    MatchSolver matchSolver = const MatchSolver(),
  })  : _gameClient = gameClient,
        _matchMakerRepository = matchMakerRepository,
        _matchSolver = matchSolver,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
    on<PlayerPlayed>(_onPlayerPlayed);
    on<MatchStateUpdated>(_onMatchStateUpdated);
  }

  final GameClient _gameClient;
  final MatchMakerRepository _matchMakerRepository;
  final MatchSolver _matchSolver;
  final bool isHost;

  StreamSubscription<MatchState>? _stateSubscription;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const MatchLoadingState());

      final values = await Future.wait([
        _gameClient.getMatch(event.matchId),
        _gameClient.getMatchState(event.matchId),
      ]);

      final match = values.first as Match?;
      final matchState = values.last as MatchState?;

      if (match == null || matchState == null) {
        emit(const MatchLoadFailedState());
      } else {
        emit(
          MatchLoadedState(
            match: match,
            matchState: matchState,
            turns: const [],
            playerPlayed: false,
          ),
        );

        final stream = _matchMakerRepository.watchMatchState(matchState.id);

        _stateSubscription = stream.listen((state) {
          add(MatchStateUpdated(state));
        });
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

  Future<void> _onPlayerPlayed(
    PlayerPlayed event,
    Emitter<GameState> emit,
  ) async {
    if (state is MatchLoadedState) {
      final matchState = state as MatchLoadedState;
      emit(matchState.copyWith(playerPlayed: true));
      await _gameClient.playCard(
        matchId: matchState.match.id,
        cardId: event.cardId,
        isHost: isHost,
      );
    }
  }

  bool isWiningCard(Card card, {required bool isPlayer}) {
    if (state is MatchLoadedState) {
      final isCardFromHost = isPlayer ? isHost : !isHost;

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

          return isCardFromHost
              ? result == MatchResult.host
              : result == MatchResult.guest;
        }
      }
    }

    return false;
  }

  bool canPlayerPlay() {
    if (state is MatchLoadedState) {
      final matchLoadedState = state as MatchLoadedState;
      return _matchSolver.canPlayCard(
        matchLoadedState.matchState,
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
