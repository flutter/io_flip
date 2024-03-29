import 'dart:async';
import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:config_repository/config_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  MatchMakingBloc({
    required MatchMakerRepository matchMakerRepository,
    required ConfigRepository configRepository,
    required ConnectionRepository connectionRepository,
    required GameResource gameResource,
    required this.deckId,
    Random? rng,
    this.hostWaitTime = defaultHostWaitTime,
  })  : _matchMakerRepository = matchMakerRepository,
        _configRepository = configRepository,
        _connectionRepository = connectionRepository,
        _gameResource = gameResource,
        _rng = rng ?? Random(),
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
    on<PrivateMatchRequested>(_onPrivateMatchRequested);
    on<GuestPrivateMatchRequested>(_onGuestPrivateMatchRequested);
  }

  final MatchMakerRepository _matchMakerRepository;
  final ConfigRepository _configRepository;
  final GameResource _gameResource;
  final String deckId;
  final ConnectionRepository _connectionRepository;

  final Random _rng;
  static const defaultHostWaitTime = Duration(seconds: 2);
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

      final cpuChance = await _configRepository.getCPUAutoMatchPercentage();
      final forcedCpu = _rng.nextDouble() < cpuChance;

      final futures = await Future.wait([
        _matchMakerRepository.findMatch(
          deckId,
          forcedCpu: forcedCpu,
        ),
        _configRepository.getMatchWaitTimeLimit(),
      ]);

      final match = futures.first as DraftMatch;
      final waitTime = futures.last as int;

      if (forcedCpu) {
        await _gameResource.connectToCpuMatch(matchId: match.id);
        emit(
          state.copyWith(
            match: match.copyWithGuest(guest: 'CPU_${match.host}'),
            status: MatchMakingStatus.completed,
            isHost: true,
          ),
        );
      } else {
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
            isPrivate: false,
            draftMatch: match,
            emit: emit,
            waitTime: waitTime,
          );
        }
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

      final futures = await Future.wait([
        _matchMakerRepository.createPrivateMatch(deckId),
        _configRepository.getPrivateMatchTimeLimit(),
      ]);
      final match = futures.first as DraftMatch;
      final waitTime = futures.last as int;

      await _connectToMatch(
        matchId: match.id,
        isHost: true,
      );
      await _waitGuestToJoin(
        isPrivate: true,
        draftMatch: match,
        emit: emit,
        waitTime: waitTime,
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
      final match = await _matchMakerRepository.joinPrivateMatch(
        guestId: deckId,
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
    required bool isPrivate,
    required DraftMatch draftMatch,
    required Emitter<MatchMakingState> emit,
    required int waitTime,
  }) async {
    final stream = _matchMakerRepository
        .watchMatch(draftMatch.id)
        .where((match) => match.guest != null);

    emit(state.copyWith(match: draftMatch));

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
      Duration(seconds: waitTime),
      onTimeout: () async {
        await subscription.cancel();
        await Future<void>.delayed(hostWaitTime);
        if (state.status == MatchMakingStatus.completed) return;

        try {
          final match = await _gameResource.getMatch(draftMatch.id);
          if (match == null) {
            emit(state.copyWith(status: MatchMakingStatus.timeout));
            return;
          }
          emit(
            state.copyWith(
              match: draftMatch.copyWithGuest(guest: match.guestDeck.userId),
              status: MatchMakingStatus.completed,
              isHost: true,
            ),
          );
          return;
        } catch (_) {
          try {
            await _gameResource.connectToCpuMatch(matchId: draftMatch.id);
            emit(
              state.copyWith(
                match:
                    draftMatch.copyWithGuest(guest: 'CPU_${draftMatch.host}'),
                status: MatchMakingStatus.completed,
                isHost: true,
              ),
            );
          } catch (e, s) {
            addError(e, s);
            _connectionRepository.send(const WebSocketMessage.matchLeft());
            emit(state.copyWith(status: MatchMakingStatus.timeout));
          }
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
