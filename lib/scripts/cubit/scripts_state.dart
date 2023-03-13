part of 'scripts_cubit.dart';

enum ScriptsStateStatus {
  loading,
  loaded,
  failed,
}

class ScriptsState extends Equatable {
  const ScriptsState({
    required this.status,
    required this.current,
  });

  final ScriptsStateStatus status;
  final String current;

  ScriptsState copyWith({
    ScriptsStateStatus? status,
    String? current,
  }) {
    return ScriptsState(
      status: status ?? this.status,
      current: current ?? this.current,
    );
  }

  @override
  List<Object?> get props => [status, current];
}
