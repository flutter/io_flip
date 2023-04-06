// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/connection/connection.dart';

void main() {
  group('ConnectionState', () {
    group('ConnectionInitial', () {
      test('uses value equality', () {
        expect(
          ConnectionInitial(),
          equals(ConnectionInitial()),
        );
      });
    });

    group('ConnectionInProgress', () {
      test('uses value equality', () {
        expect(
          ConnectionInProgress(),
          equals(ConnectionInProgress()),
        );
      });
    });

    group('ConnectionSuccess', () {
      test('uses value equality', () {
        expect(
          ConnectionSuccess(),
          equals(ConnectionSuccess()),
        );
      });
    });

    group('ConnectionFailure', () {
      test('uses value equality', () {
        expect(
          ConnectionFailure(WebSocketErrorCode.playerAlreadyConnected),
          equals(ConnectionFailure(WebSocketErrorCode.playerAlreadyConnected)),
        );
        expect(
          ConnectionFailure(WebSocketErrorCode.playerAlreadyConnected),
          isNot(
            equals(
              ConnectionFailure(WebSocketErrorCode.firebaseException),
            ),
          ),
        );
      });
    });
  });
}
