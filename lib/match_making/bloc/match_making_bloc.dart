import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/match_making/match_making.dart';

part 'match_making_event.dart';
part 'match_making_state.dart';

class MatchMakingBloc extends Bloc<MatchMakingEvent, MatchMakingState> {
  MatchMakingBloc({
    required MatchMaker matchMaker,
    required this.playerId,
    this.hostWaitTime = defaultHostWaitTime,
    this.pingInterval = defaultPingInterval,
  })  : _matchMaker = matchMaker,
        super(const MatchMakingState.initial()) {
    on<MatchRequested>(_onMatchRequested);
  }

  final MatchMaker _matchMaker;
  final String playerId;

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
      final match = await _matchMaker.findMatch(playerId);

      if (match.guest != null) {
        emit(
          state.copyWith(
            match: match,
            status: MatchMakingStatus.completed,
          ),
        );
      } else {
        final stream = _matchMaker
            .watchMatch(match.id)
            .where((match) => match.guest != null);

        emit(state.copyWith(match: match));

        final completer = Completer<void>();

        late StreamSubscription<Match> subscription;

        var pinging = false;
        final timer = Timer.periodic(pingInterval, (_) async {
          if (!pinging) {
            pinging = true;
            await _matchMaker.pingMatch(match.id);
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
