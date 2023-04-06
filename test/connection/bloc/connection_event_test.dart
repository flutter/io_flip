// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/connection/connection.dart';

void main() {
  group('ConnectionEvent', () {
    group('ConnectionRequested', () {
      test('uses value equality', () {
        expect(
          ConnectionRequested(),
          equals(ConnectionRequested()),
        );
      });
    });

    group('ConnectionClosed', () {
      test('uses value equality', () {
        expect(
          ConnectionClosed(),
          equals(ConnectionClosed()),
        );
      });
    });

    group('WebSocketMessageReceived', () {
      test('uses value equality', () {
        final a = WebSocketMessageReceived(WebSocketMessage.connected());
        final b = WebSocketMessageReceived(WebSocketMessage.connected());
        final c = WebSocketMessageReceived(
          WebSocketMessage.error(
            WebSocketErrorCode.playerAlreadyConnected,
          ),
        );
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });
  });
}
