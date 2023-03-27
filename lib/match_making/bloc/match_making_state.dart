part of 'match_making_bloc.dart';

enum MatchMakingStatus {
  initial,
  processing,
  timeout,
  failed,
  completed,
}

class MatchMakingState extends Equatable {
  const MatchMakingState({
    required this.status,
    this.isHost = false,
    this.match,
    this.matchConnection,
  });

  const MatchMakingState.initial()
      : this(
          status: MatchMakingStatus.initial,
        );

  final Match? match;
  final MatchMakingStatus status;
  final bool isHost;
  final WebSocket? matchConnection;

  MatchMakingState copyWith({
    Match? match,
    MatchMakingStatus? status,
    bool? isHost,
    WebSocket? matchConnection,
  }) {
    return MatchMakingState(
      match: match ?? this.match,
      status: status ?? this.status,
      isHost: isHost ?? this.isHost,
      matchConnection: matchConnection ?? this.matchConnection,
    );
  }

  @override
  List<Object?> get props => [
        status,
        match,
        isHost,
        matchConnection,
      ];
}
