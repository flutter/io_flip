import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  MatchMakingBloc({
    required MatchMakerRepository matchMakerRepository,
    required GameClient gameClient,
    required User user,
    required this.cardIds,
    this.hostWaitTime = defaultHostWaitTime,
  })  : _matchMakerRepository = matchMakerRepository,
        _gameClient = gameClient,
        _user = user,
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
    on<PrivateMatchRequested>(_onPrivateMatchRequested);
    on<GuestPrivateMatchRequested>(_onGuestPrivateMatchRequested);
  }

  final MatchMakerRepository _matchMakerRepository;
  final GameClient _gameClient;
  final User _user;
  final List<String> cardIds;

  static const defaultHostWaitTime = Duration(seconds: 4);
  final Duration hostWaitTime;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<MatchMakingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchMakingStatus.processing));
      final playerId = await _gameClient.createDeck(
        cardIds: cardIds,
        userId: _user.id,
      );
      final match = await _matchMakerRepository.findMatch(playerId);

      if (match.guest != null) {
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
      final playerId = await _gameClient.createDeck(
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
      final playerId = await _gameClient.createDeck(
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
        ),
      );
      subscription.cancel();
    });

    // TODO(willhlas): Add timeout to doWhile loop
    //  indicating that the host has not been able to find a guest.
    await Future.doWhile(() async {
      await Future<void>.delayed(hostWaitTime);

      if (!isClosed && state.status == MatchMakingStatus.processing) {
        await _matchMakerRepository.pingHost(match.id);
        return Future.value(true);
      }

      return Future.value(false);
    });
  }
}
