import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  MatchMakingBloc({
    required MatchMakerRepository matchMakerRepository,
    required GameResource gameResource,
    required User user,
    required this.cardIds,
    this.hostWaitTime = defaultHostWaitTime,
  })  : _matchMakerRepository = matchMakerRepository,
        _gameResource = gameResource,
        _user = user,
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
    on<PrivateMatchRequested>(_onPrivateMatchRequested);
    on<GuestPrivateMatchRequested>(_onGuestPrivateMatchRequested);
  }

  final MatchMakerRepository _matchMakerRepository;
  final GameResource _gameResource;
  final User _user;
  final List<String> cardIds;
  late WebSocket _matchConnection;

  static const defaultHostWaitTime = Duration(seconds: 4);
  final Duration hostWaitTime;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<MatchMakingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchMakingStatus.processing));
      final playerId = await _gameResource.createDeck(
        cardIds: cardIds,
        userId: _user.id,
      );
      final match = await _matchMakerRepository.findMatch(playerId);

      if (match.guest != null) {
        _matchConnection = await _gameResource.connectToMatch(
          matchId: match.id,
          isHost: false,
        );
        emit(
          state.copyWith(
            match: match,
            status: MatchMakingStatus.completed,
            isHost: false,
            matchConnection: _matchConnection,
          ),
        );
      } else {
        _matchConnection = await _gameResource.connectToMatch(
          matchId: match.id,
          isHost: true,
        );
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
      final playerId = await _gameResource.createDeck(
        cardIds: cardIds,
        userId: _user.id,
      );
      final match = await _matchMakerRepository.createPrivateMatch(playerId);

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
      final playerId = await _gameResource.createDeck(
        cardIds: cardIds,
        userId: _user.id,
      );
      final match = await _matchMakerRepository.joinPrivateMatch(
        guestId: playerId,
        inviteCode: event.inviteCode,
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
    required Match match,
    required Emitter<MatchMakingState> emit,
  }) async {
    final stream = _matchMakerRepository
        .watchMatch(match.id)
        .where((match) => match.guest != null);

    emit(state.copyWith(match: match));

    late StreamSubscription<Match> subscription;

    subscription = stream.listen((newMatch) {
      emit(
        state.copyWith(
          match: newMatch,
          status: MatchMakingStatus.completed,
          isHost: true,
          matchConnection: _matchConnection,
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
      const Duration(seconds: 30),
      onTimeout: () {
        subscription.cancel();
        emit(state.copyWith(status: MatchMakingStatus.timeout));
      },
    );
  }
}
