// ignore_for_file: prefer_const_constructors

import 'package:dart_frog/dart_frog.dart';
import 'package:encryption_middleware/encryption_middleware.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockResponse extends Mock implements Response {}

void main() {
  group('EncryptionMiddleware', () {
    const key = '12345678901234567890123456789012';
    const iv = '1234567890123456';
    const testBody = "{'test': 'data'}";

    test('can be instantiated', () {
      expect(EncryptionMiddleware(), isNotNull);
    });

    test('throws error if ENCRYPTION_KEY is not in environment', () async {
      final handler = EncryptionMiddleware().middleware(
        (_) async => Response.json(body: 'test'),
      );

      final context = _MockRequestContext();

      expect(
        () => handler(context),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            equals('ENCRYPTION_KEY is required to run the API'),
          ),
        ),
      );
    });

    test('throws error if ENCRYPTION_IV is not in environment', () async {
      final handler = EncryptionMiddleware(
        key: key,
      ).middleware(
        (_) async => Response.json(body: 'test'),
      );

      final context = _MockRequestContext();

      expect(
        () => handler(context),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            equals('ENCRYPTION_IV is required to run the API'),
          ),
        ),
      );
    });

    test('returns original response if body is empty', () async {
      final mockResponse = _MockResponse();

      when(mockResponse.body).thenAnswer((_) async => '');

      final handler = EncryptionMiddleware().middleware(
        (_) async => mockResponse,
      );

      final context = _MockRequestContext();
      final response = await handler(context);
      final body = await response.body();

      expect(body, equals(''));
    });

    test('encrypts response body', () async {
      final mockResponse = _MockResponse();
      final encryptedResponse = _MockResponse();

      when(mockResponse.body).thenAnswer((_) async => testBody);
      when(encryptedResponse.body).thenAnswer((_) async => '123');
      when(
        () => mockResponse.copyWith(body: any(named: 'body')),
      ).thenAnswer(
        (_) => encryptedResponse,
      );

      final handler = EncryptionMiddleware(
        key: key,
        iv: iv,
      ).middleware((_) async => mockResponse);

      final context = _MockRequestContext();
      final response = await handler(context);
      final body = await response.body();

      expect(body, equals('123'));
    });
  });
}
