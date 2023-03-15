// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockResponse extends Mock implements Response {}

// ignore: one_member_abstracts
abstract class __HttpClient {
  Future<Response> onPost(Uri uri, {Object? body});
  Future<Response> onPut(Uri uri, {Object? body});
}

class _MockHttpClient extends Mock implements __HttpClient {}

void main() {
  group('GameClient', () {
    setUpAll(() {
      registerFallbackValue(Uri());
    });

    test('can be instantiated', () {
      expect(
        GameClient(endpoint: ''),
        isNotNull,
      );
    });

    group('generateCard', () {
      late GameClient client;
      late Response response;

      setUp(() {
        response = _MockResponse();

        client = GameClient(
          endpoint: '',
          postCall: (_, {Object? body}) async => response,
        );
      });

      test('returns a Card', () async {
        const card = Card(
          id: '',
          name: 'Dash',
          description: 'Cute blue bird',
          image: 'image.png',
          rarity: true,
          power: 1,
          suit: Suit.air,
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(card.toJson()));
        final returnedCard = await client.generateCard();

        expect(returnedCard, equals(card));
      });

      test('throws GameClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

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
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

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
      late GameClient client;
      late Response response;

      setUp(() {
        response = _MockResponse();

        client = GameClient(
          endpoint: '',
          postCall: (_, {Object? body}) async => response,
        );
      });

      test('returns the deck id', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'id': 'deck'}));

        final id = await client.createDeck(
          cardIds: ['a', 'b', 'c'],
          userId: 'mock-userId',
        );

        expect(id, equals('deck'));
      });

      test('throws GameClientError when request fails', () async {
        final response = _MockResponse();
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        final client = GameClient(
          endpoint: '',
          postCall: (_, {Object? body}) async => response,
        );

        await expectLater(
          () => client.createDeck(
            cardIds: ['a', 'b', 'c'],
            userId: 'mock-userId',
          ),
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
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.createDeck(
            cardIds: ['a', 'b', 'c'],
            userId: 'mock-userId',
          ),
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

    group('getDeck', () {
      late GameClient client;
      late Response response;

      setUp(() {
        response = _MockResponse();

        client = GameClient(
          endpoint: '',
          getCall: (_) async => response,
        );
      });

      test('returns a deck', () async {
        const card = Card(
          id: '',
          name: 'Dash',
          description: 'Cute blue bird',
          image: 'image.png',
          rarity: true,
          power: 1,
          suit: Suit.air,
        );

        const deck = Deck(
          id: 'deckId',
          cards: [card],
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(deck.toJson()));
        final returnedDeck = await client.getDeck('deckId');

        expect(returnedDeck, equals(deck));
      });

      test('throws GameClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.getDeck('deckId'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /decks/deckId returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.getDeck('deckId'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /decks/deckId returned invalid response "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('getMatch', () {
      late GameClient client;
      late Response response;

      setUp(() {
        response = _MockResponse();

        client = GameClient(
          endpoint: '',
          getCall: (_) async => response,
        );
      });

      test('returns a match', () async {
        const card = Card(
          id: '',
          name: 'Dash',
          description: 'Cute blue bird',
          image: 'image.png',
          rarity: true,
          power: 1,
          suit: Suit.air,
        );

        const hostDeck = Deck(
          id: 'hostDeckId',
          cards: [card],
        );

        const guestDeck = Deck(
          id: 'guestDeckId',
          cards: [card],
        );

        const match = Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(match.toJson()));
        final returnedMatch = await client.getMatch('matchId');

        expect(returnedMatch, equals(match));
      });

      test('throws GameClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.getMatch('matchId'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /matches/matchId returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.getMatch('matchId'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /matches/matchId returned invalid response "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('getMatchState', () {
      late GameClient client;
      late Response response;

      setUp(() {
        response = _MockResponse();

        client = GameClient(
          endpoint: '',
          getCall: (_) async => response,
        );
      });

      test('returns a match state', () async {
        const matchState = MatchState(
          id: 'matchStateId',
          matchId: 'matchId',
          guestPlayedCards: ['a'],
          hostPlayedCards: ['b'],
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(matchState.toJson()));
        final returnedMatchState = await client.getMatchState('matchId');

        expect(returnedMatchState, equals(matchState));
      });

      test('returns null when is not found', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        final returnedMatchState = await client.getMatchState('matchId');

        expect(returnedMatchState, isNull);
      });

      test('throws GameClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.getMatchState('matchId'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /matches/matchId/state returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.getMatchState('matchId'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /matches/matchId/state returned invalid response "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('playCard', () {
      late __HttpClient httpClient;
      late GameClient client;
      late Response response;

      setUp(() {
        httpClient = _MockHttpClient();

        response = _MockResponse();
        when(() => httpClient.onPost(any(), body: any(named: 'body')))
            .thenAnswer((_) async => response);

        client = GameClient(
          endpoint: '',
          postCall: httpClient.onPost,
        );
      });

      test('makes the correct call', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        await client.playCard(
          matchId: 'matchId',
          cardId: 'cardId',
          isHost: true,
        );

        verify(
          () => httpClient.onPost(
            Uri.parse(
              '/matches/move?matchId=matchId&cardId=cardId&host=true',
            ),
          ),
        ).called(1);
      });

      test('makes the correct call', () async {
        when(() => httpClient.onPost(any(), body: any(named: 'body')))
            .thenThrow(Exception('Ops'));

        await expectLater(
          () => client.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            isHost: true,
          ),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/move failed with the following message: "Exception: Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when the returns error code', () async {
        when(() => response.statusCode).thenReturn(
          HttpStatus.internalServerError,
        );
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            isHost: true,
          ),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/move returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws GameClientError when the request breaks', () async {
        when(() => httpClient.onPost(any(), body: any(named: 'body')))
            .thenThrow(Exception('Ops'));

        await expectLater(
          () => client.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            isHost: true,
          ),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/move failed with the following message: "Exception: Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('getCurrentScript', () {
      late GameClient client;
      late Response response;

      setUp(() {
        response = _MockResponse();

        client = GameClient(
          endpoint: '',
          getCall: (_, {Object? body}) async => response,
        );
      });

      test('returns the script', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('script');
        final returnedScript = await client.getCurrentScript();

        expect(returnedScript, equals('script'));
      });

      test('throws GameClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          client.getCurrentScript,
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /scripts/current returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('updateScript', () {
      late __HttpClient httpClient;
      late GameClient client;
      late Response response;

      setUp(() {
        httpClient = _MockHttpClient();
        response = _MockResponse();
        when(() => httpClient.onPut(any(), body: any(named: 'body')))
            .thenAnswer((_) async => response);

        client = GameClient(
          endpoint: '',
          putCall: httpClient.onPut,
        );
      });

      test('send the correct request', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        await client.updateScript('current', 'script');

        verify(
          () => httpClient.onPut(Uri.parse('/scripts/current'), body: 'script'),
        );
      });

      test('throws GameClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => client.updateScript('current', 'script'),
          throwsA(
            isA<GameClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'PUT /scripts/current returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('GameClientError', () {
      test('toString returns the cause', () {
        expect(
          GameClientError('Ops', StackTrace.empty).toString(),
          equals('Ops'),
        );
      });
    });
  });
}
