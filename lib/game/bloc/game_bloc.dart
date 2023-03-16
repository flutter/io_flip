import 'dart:async';
import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart' as repo;

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameClient gameClient,
    required repo.MatchMakerRepository matchMakerRepository,
    required MatchSolver matchSolver,
    required User user,
    required this.isHost,
    this.timeOutPeriod = defaultTimeOutPeriod,
    this.pingInterval = defaultPingInterval,
    ValueGetter<Timestamp> now = Timestamp.now,
  })  : _gameClient = gameClient,
        _matchMakerRepository = matchMakerRepository,
        _matchSolver = matchSolver,
        _user = user,
        _now = now,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
    on<PlayerPlayed>(_onPlayerPlayed);
    on<MatchStateUpdated>(_onMatchStateUpdated);
    on<ManagePlayerPresence>(_onManagePlayerPresence);
  }

  final GameClient _gameClient;
  final repo.MatchMakerRepository _matchMakerRepository;
  final MatchSolver _matchSolver;
  final User _user;
  final bool isHost;
  static const defaultTimeOutPeriod = Duration(seconds: 10);
  static const defaultPingInterval = Duration(seconds: 5);
  final Duration timeOutPeriod;
  final Duration pingInterval;
  final ValueGetter<Timestamp> _now;

  StreamSubscription<MatchState>? _stateSubscription;
  StreamSubscription<repo.Match>? _opponentPresenceSubscription;

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

        add(ManagePlayerPresence(event.matchId));
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

      final deckId =
          isHost ? matchState.match.hostDeck.id : matchState.match.guestDeck.id;

      await _gameClient.playCard(
        matchId: matchState.match.id,
        cardId: event.cardId,
        deckId: deckId,
        userId: _user.id,
      );
    }
  }

  Future<void> _onManagePlayerPresence(
    ManagePlayerPresence event,
    Emitter<GameState> emit,
  ) async {
    try {
      final completer = Completer<void>();
      final matchStream = _matchMakerRepository.watchMatch(event.matchId);
      final stalePingMatchStream = matchStream.where(_isOpponentAbsent);

      var pinging = false;
      final timer = Timer.periodic(pingInterval, (_) async {
        try {
          if (!pinging) {
            pinging = true;
            isHost
                ? await _matchMakerRepository.pingHost(event.matchId)
                : await _matchMakerRepository.pingGuest(event.matchId);
            pinging = false;
          }
        } catch (e, s) {
          addError(e, s);
          emit(const PingFailedState());
        }
      });

      _opponentPresenceSubscription = stalePingMatchStream.listen(
        (expiredMatch) {
          emit(const OpponentAbsentState());
          if (!isClosed) timer.cancel();
          completer.complete();
        },
      );

      return completer.future;
    } catch (e, s) {
      addError(e, s);
      emit(const ManagePlayerPresenceFailedState());
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
    _opponentPresenceSubscription?.cancel();
    return super.close();
  }

  bool _isOpponentAbsent(repo.Match match) {
    final now = _now().millisecondsSinceEpoch;

    final opponentPing = isHost
        ? match.guestPing?.millisecondsSinceEpoch ?? 0
        : match.hostPing.millisecondsSinceEpoch;
    return now - opponentPing >= timeOutPeriod.inMilliseconds;
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
