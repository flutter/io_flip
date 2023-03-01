import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameClient gameClient,
  })  : _gameClient = gameClient,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
  }

  final GameClient _gameClient;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<GameState> emit,
  ) async {
      emit(const MatchLoadingState());

      final match = await _gameClient.getMatch(event.matchId);

      if (match == null) {
        emit(const MatchLoadFailedState());
      } else {
        emit(MatchLoadedState(match));
      }
    try {
    } catch (e, s) {
      addError(e, s);
      emit(const MatchLoadFailedState());
    }
  }
}
