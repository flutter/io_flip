part of 'connection_bloc.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();

  @override
  List<Object> get props => [];
}

class ConnectionInitial extends ConnectionState {
  const ConnectionInitial();
}

class ConnectionInProgress extends ConnectionState {
  const ConnectionInProgress();
}

class ConnectionSuccess extends ConnectionState {
  const ConnectionSuccess();
}

class ConnectionFailure extends ConnectionState {
  const ConnectionFailure(this.error);

  final WebSocketErrorCode error;

  @override
  List<Object> get props => [error];
}
