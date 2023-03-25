import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  // Connect to the remote WebSocket endpoint.
  final uri = Uri.parse(
      "ws://localhost:8080/matches/1ldDtz5qg33hKt95Y4l2/connect?host=true");
  final channel = WebSocketChannel.connect(uri);

  // Send a message to the server.
  channel.sink.add('hello');

  // Subscribe to messages from the server.
  channel.stream.listen((message) {
    print(message);
  });
}
