import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc({
    required LeaderboardResource leaderboardResource,
  })  : _leaderboardResource = leaderboardResource,
        super(const LeaderboardState.initial()) {
    on<LeaderboardRequested>(_onLeaderboardRequested);
  }

  final LeaderboardResource _leaderboardResource;

  Future<void> _onLeaderboardRequested(
    LeaderboardRequested event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LeaderboardStateStatus.loading));

      final leaderboard = await _leaderboardResource.getLeaderboardResults();

      emit(
        state.copyWith(
          leaderboard: leaderboard,
          status: LeaderboardStateStatus.loaded,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: LeaderboardStateStatus.failed));
    }
  }
}
