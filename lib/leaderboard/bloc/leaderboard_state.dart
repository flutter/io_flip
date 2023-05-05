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
    required this.leaderboard,
  });

  const LeaderboardState.initial()
      : this(
          status: LeaderboardStateStatus.initial,
          leaderboard: const [],
        );

  final LeaderboardStateStatus status;
  final List<LeaderboardPlayer> leaderboard;

  LeaderboardState copyWith({
    LeaderboardStateStatus? status,
    List<LeaderboardPlayer>? leaderboard,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }

  @override
  List<Object?> get props => [status, leaderboard];
}
