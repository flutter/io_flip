import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameClient gameClient,
    required this.isHost,
  })  : _gameClient = gameClient,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
  }

  final GameClient _gameClient;
  final bool isHost;

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
          ),
        );
      }
    } catch (e, s) {
      addError(e, s);
      emit(const MatchLoadFailedState());
    }
  }
}
