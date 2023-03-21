import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:match_repository/match_repository.dart';

Handler get onRequest {
  return webSocketHandler((channel, protocol) {
    channel.stream.listen(
      (message) {
        print(message);
      },
      onDone: () {},
    );
  });
}
