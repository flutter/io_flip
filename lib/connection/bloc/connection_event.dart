part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object> get props => [];
}

class ConnectionRequested extends ConnectionEvent {
  const ConnectionRequested();
}

class ConnectionClosed extends ConnectionEvent {
  const ConnectionClosed();
}

class WebSocketMessageReceived extends ConnectionEvent {
  const WebSocketMessageReceived(this.message);

  final WebSocketMessage message;

  @override
  List<Object> get props => [message];
}
