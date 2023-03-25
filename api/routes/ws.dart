import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      // Handle incoming client messages.
      print(message);
    });

    // Send a message back to the client.
    channel.sink.add('hi');
  });
  return handler(context);
}
