// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockResponse extends Mock implements Response {}

void main() {
  group('GameClient', () {
    test('can be instantiated', () {
      expect(
        GameClient(endpoint: ''),
        isNotNull,
      );
    });

    group('generateCard', () {
      test('returns a Card', () async {
        const card = Card(
          id: '',
          name: 'Dash',
          description: 'Cute blue bird',
          image: 'image.png',
          rarity: true,
          power: 1,
        );

        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(card.toJson()));

        final client =
            GameClient(endpoint: '', postCall: (_) async => response,);
        final returnedCard = await client.generateCard();

        expect(returnedCard, equals(card));
      });

      test('throws GameClientError when request fails', () async {
        final response = _MockResponse();
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        final client =
            GameClient(endpoint: '', postCall: (_) async => response,);

        await expectLater(
          client.generateCard,
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /cards returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when request response is invalid', () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        final client =
            GameClient(endpoint: '', postCall: (_) async => response,);

        await expectLater(
          client.generateCard,
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /cards returned invalid response "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('createDeck', () {
      test('returns the deck id', () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'id': 'deck'}));

        final client =
            GameClient(endpoint: '', postCall: (_) async => response);
        final id = await client.createDeck(['a', 'b', 'c']);

        expect(id, equals('deck'));
      });

      test('throws GameClientError when request fails', () async {
        final response = _MockResponse();
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        final client =
            GameClient(endpoint: '', postCall: (_) async => response,);

        await expectLater(
          () => client.createDeck(['a','b', 'c']),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /decks returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when request response is invalid', () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        final client =
            GameClient(endpoint: '', postCall: (_) async => response,);

        await expectLater(
          () => client.createDeck(['a','b', 'c']),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /decks returned invalid response "Ops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
