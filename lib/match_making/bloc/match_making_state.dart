part of 'match_making_bloc.dart';

enum MatchMakingStatus {
  initial,
  processing,
  failed,
  completed,
}

class MatchMakingState extends Equatable {
  const MatchMakingState({
    required this.status,
    this.match,
  });

  const MatchMakingState.initial()
      : this(
          status: MatchMakingStatus.initial,
        );

  final Match? match;
  final MatchMakingStatus status;

  MatchMakingState copyWith({
    Match? match,
    MatchMakingStatus? status,
  }) {
    return MatchMakingState(
      match: match ?? this.match,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
        match,
      ];
}
