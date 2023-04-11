part of 'leaderboard_bloc.dart';

enum LeaderboardStateStatus {
  initial,
  loading,
  loaded,
  failed,
}

class LeaderboardState extends Equatable {
  const LeaderboardState({
    required this.status,
    this.leaderboard,
  });

  const LeaderboardState.initial()
      : this(
          status: LeaderboardStateStatus.initial,
        );

  final LeaderboardStateStatus status;
  final LeaderboardResults? leaderboard;

  LeaderboardState copyWith({
    LeaderboardStateStatus? status,
    LeaderboardResults? leaderboard,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }

  @override
  List<Object?> get props => [status, leaderboard];
}
