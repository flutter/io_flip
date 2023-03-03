import 'dart:async';

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
    required this.cardIds,
    this.hostWaitTime = defaultHostWaitTime,
    this.pingInterval = defaultPingInterval,
  })  : _matchMakerRepository = matchMakerRepository,
        _gameClient = gameClient,
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
  }

  final GameClient _gameClient;
  final MatchMakerRepository _matchMakerRepository;
  final List<String> cardIds;

  static const defaultHostWaitTime = Duration(seconds: 4);
  final Duration hostWaitTime;

  static const defaultPingInterval = Duration(milliseconds: 100);
  final Duration pingInterval;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<MatchMakingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchMakingStatus.processing));
      final playerId = await _gameClient.createDeck(cardIds);
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
        final stream = _matchMakerRepository
            .watchMatch(match.id)
            .where((match) => match.guest != null);

        emit(state.copyWith(match: match));

        final completer = Completer<void>();

        late StreamSubscription<Match> subscription;

        var pinging = false;
        final timer = Timer.periodic(pingInterval, (_) async {
          if (!pinging) {
            pinging = true;
            await _matchMakerRepository.pingMatch(match.id);
            pinging = false;
          }
        });

        Future<void>.delayed(hostWaitTime, () {
          if (!isClosed) {
            if (state.status == MatchMakingStatus.processing) {
              timer.cancel();
              subscription.cancel();
              completer.complete();
              add(const MatchRequested());
            }
          }
        });

        subscription = stream.listen((newMatch) {
          emit(
            state.copyWith(
              match: newMatch,
              status: MatchMakingStatus.completed,
              isHost: true,
            ),
          );
          timer.cancel();
          completer.complete();
          subscription.cancel();
        });

        return completer.future;
      }
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: MatchMakingStatus.failed));
    }
  }
}
