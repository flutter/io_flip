import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  MatchMakingBloc({
    required MatchMakerRepository matchMakerRepository,
    required ConnectionRepository connectionRepository,
    required GameResource gameResource,
    required this.cardIds,
    this.hostWaitTime = defaultHostWaitTime,
    this.guestWaitingTimeout = 30,
  })  : _matchMakerRepository = matchMakerRepository,
        _connectionRepository = connectionRepository,
        _gameResource = gameResource,
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
    on<PrivateMatchRequested>(_onPrivateMatchRequested);
    on<GuestPrivateMatchRequested>(_onGuestPrivateMatchRequested);
  }

  @visibleForTesting
  MatchMakingBloc.test({
    required MatchMakerRepository matchMakerRepository,
    required ConnectionRepository connectionRepository,
    required GameResource gameResource,
    required this.cardIds,
    this.hostWaitTime = defaultHostWaitTime,
    this.guestWaitingTimeout = 1,
  })  : _matchMakerRepository = matchMakerRepository,
        _connectionRepository = connectionRepository,
        _gameResource = gameResource,
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
    on<PrivateMatchRequested>(_onPrivateMatchRequested);
    on<GuestPrivateMatchRequested>(_onGuestPrivateMatchRequested);
  }

  final MatchMakerRepository _matchMakerRepository;
  final GameResource _gameResource;
  final List<String> cardIds;
  final int guestWaitingTimeout;
  final ConnectionRepository _connectionRepository;

  static const defaultHostWaitTime = Duration(seconds: 4);
  final Duration hostWaitTime;

  Future<void> _connectToMatch({
    required String matchId,
    required bool isHost,
  }) async {
    _connectionRepository.send(
      WebSocketMessage.matchJoined(
        matchId: matchId,
        isHost: isHost,
      ),
    );
    await _connectionRepository.messages.firstWhere(
      (message) => message.messageType == MessageType.matchJoined,
    );
  }

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<MatchMakingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchMakingStatus.processing));
      final playerId = await _gameResource.createDeck(cardIds);
      final match = await _matchMakerRepository.findMatch(playerId);
      final isHost = match.guest == null;

      await _connectToMatch(
        matchId: match.id,
        isHost: isHost,
      );
      if (!isHost) {
        emit(
          state.copyWith(
            match: match,
            status: MatchMakingStatus.completed,
            isHost: false,
          ),
        );
      } else {
        await _waitGuestToJoin(
          match: match,
          emit: emit,
        );
      }
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: MatchMakingStatus.failed));
    }
  }

  Future<void> _onPrivateMatchRequested(
    PrivateMatchRequested event,
    Emitter<MatchMakingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchMakingStatus.processing));
      final playerId = await _gameResource.createDeck(cardIds);
      final match = await _matchMakerRepository.createPrivateMatch(playerId);

      await _connectToMatch(
        matchId: match.id,
        isHost: true,
      );
      await _waitGuestToJoin(
        match: match,
        emit: emit,
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: MatchMakingStatus.failed));
    }
  }

  Future<void> _onGuestPrivateMatchRequested(
    GuestPrivateMatchRequested event,
    Emitter<MatchMakingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchMakingStatus.processing));
      final playerId = await _gameResource.createDeck(cardIds);
      final match = await _matchMakerRepository.joinPrivateMatch(
        guestId: playerId,
        inviteCode: event.inviteCode,
      );
      await _connectToMatch(
        matchId: match!.id,
        isHost: false,
      );

      emit(
        state.copyWith(
          match: match,
          status: MatchMakingStatus.completed,
          isHost: false,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: MatchMakingStatus.failed));
    }
  }

  Future<void> _waitGuestToJoin({
    required DraftMatch match,
    required Emitter<MatchMakingState> emit,
  }) async {
    final stream = _matchMakerRepository
        .watchMatch(match.id)
        .where((match) => match.guest != null);

    emit(state.copyWith(match: match));

    late StreamSubscription<DraftMatch> subscription;

    subscription = stream.listen((newMatch) {
      emit(
        state.copyWith(
          match: newMatch,
          status: MatchMakingStatus.completed,
          isHost: true,
        ),
      );
      subscription.cancel();
    });

    await Future.doWhile(() async {
      await Future<void>.delayed(hostWaitTime);

      if (!isClosed && state.status == MatchMakingStatus.processing) {
        return Future.value(true);
      }

      return Future.value(false);
    }).timeout(
      Duration(seconds: guestWaitingTimeout),
      onTimeout: () async {
        await subscription.cancel();
        try {
          await _gameResource.connectToCpuMatch(matchId: match.id);
          emit(
            state.copyWith(
              match: match.copyWithGuest(guest: 'CPU_${match.host}'),
              status: MatchMakingStatus.completed,
              isHost: true,
            ),
          );
        } catch (e) {
          _connectionRepository.send(const WebSocketMessage.matchLeft());
          emit(state.copyWith(status: MatchMakingStatus.timeout));
        }
      },
    );
  }

  @override
  Future<void> close() {
    if (state.match?.guest == null) {
      _connectionRepository.send(const WebSocketMessage.matchLeft());
    }
    return super.close();
  }
}
