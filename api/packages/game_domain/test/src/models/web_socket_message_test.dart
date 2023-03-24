// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('WebSocketMessage', () {
    test('can be instantiated', () {
      expect(
        WebSocketMessage(message: ''),
        isNotNull,
      );
    });

    final message =
        WebSocketMessage(message: '', error: ErrorType.firebaseException);

    test('fromJson returns the correct instance', () {
      expect(
        WebSocketMessage.fromJson(const {
          'message': '',
          'error': 'FirebaseException',
        }),
        equals(message),
      );
    });

    test('toJson returns the correct instance', () {
      expect(
        message.toJson(),
        equals(const {
          'message': '',
          'error': 'FirebaseException',
        }),
      );
    });

    test('supports equality', () {
      expect(
        message,
        equals(
          WebSocketMessage(message: '', error: ErrorType.firebaseException),
        ),
      );

      expect(
        WebSocketMessage(
          message: '',
        ),
        isNot(
          equals(message),
        ),
      );
      expect(
        WebSocketMessage(message: 'test', error: ErrorType.firebaseException),
        isNot(
          equals(message),
        ),
      );
    });
  });
}
