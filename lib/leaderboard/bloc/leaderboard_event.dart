part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
}

class LeaderboardRequested extends LeaderboardEvent {
  const LeaderboardRequested();

  @override
  List<Object> get props => [];
}
