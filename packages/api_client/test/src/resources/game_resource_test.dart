import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

class _MockWebSocket extends Mock implements WebSocket {}

class _MockConnection extends Mock implements Connection {}

void main() {
  group('GameResource', () {
    late ApiClient apiClient;
    late http.Response response;
    late GameResource resource;
    late WebSocket webSocket;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();
      webSocket = _MockWebSocket();

      when(
        () => apiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => response);
      when(
        () => apiClient.post(
          any(),
          queryParameters: any(named: 'queryParameters'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);
      when(
        () => apiClient.put(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      resource = GameResource(apiClient: apiClient, websocket: webSocket);
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
          suit: Suit.air,
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(card.toJson()));
        final returnedCard = await resource.generateCard();

        expect(returnedCard, equals(card));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          resource.generateCard,
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /cards returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          resource.generateCard,
          throwsA(
            isA<ApiClientError>().having(
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
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'id': 'deck'}));

        final id = await resource.createDeck(
          cardIds: ['a', 'b', 'c'],
          userId: 'mock-userId',
        );

        expect(id, equals('deck'));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        final resource = GameResource(
          apiClient: apiClient,
        );

        await expectLater(
          () => resource.createDeck(
            cardIds: ['a', 'b', 'c'],
            userId: 'mock-userId',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /decks returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.createDeck(
            cardIds: ['a', 'b', 'c'],
            userId: 'mock-userId',
          ),
          throwsA(
            isA<ApiClientError>().having(
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
          userId: 'userId',
          cards: [card],
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(deck.toJson()));
        final returnedDeck = await resource.getDeck('deckId');

        expect(returnedDeck, equals(deck));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.getDeck('deckId'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /decks/deckId returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.getDeck('deckId'),
          throwsA(
            isA<ApiClientError>().having(
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
          userId: 'hostUserId',
          cards: [card],
        );

        const guestDeck = Deck(
          id: 'guestDeckId',
          userId: 'guestUserId',
          cards: [card],
        );

        const match = Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(match.toJson()));
        final returnedMatch = await resource.getMatch('matchId');

        expect(returnedMatch, equals(match));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.getMatch('matchId'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /matches/matchId returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.getMatch('matchId'),
          throwsA(
            isA<ApiClientError>().having(
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
      test('returns a match state', () async {
        const matchState = MatchState(
          id: 'matchStateId',
          matchId: 'matchId',
          guestPlayedCards: ['a'],
          hostPlayedCards: ['b'],
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(matchState.toJson()));
        final returnedMatchState = await resource.getMatchState('matchId');

        expect(returnedMatchState, equals(matchState));
      });

      test('returns null when is not found', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        final returnedMatchState = await resource.getMatchState('matchId');

        expect(returnedMatchState, isNull);
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.getMatchState('matchId'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /matches/matchId/state returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.getMatchState('matchId'),
          throwsA(
            isA<ApiClientError>().having(
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
      test('makes the correct call', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        await resource.playCard(
          matchId: 'matchId',
          cardId: 'cardId',
          deckId: 'deckId',
          userId: 'userId',
        );

        verify(
          () => apiClient.post(
            '/matches/move',
            queryParameters: {
              'matchId': 'matchId',
              'cardId': 'cardId',
              'deckId': 'deckId',
              'userId': 'userId',
            },
          ),
        ).called(1);
      });

      test('throws an ApiClientError when the request fails', () async {
        when(
          () => apiClient.post(
            any(),
            body: any(named: 'body'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Ops'));

        await expectLater(
          () => resource.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            deckId: 'deckId',
            userId: 'userId',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/move failed with the following message: "Exception: Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when the returns error code', () async {
        when(() => response.statusCode).thenReturn(
          HttpStatus.internalServerError,
        );
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            deckId: 'deckId',
            userId: 'userId',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/move returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when the request breaks', () async {
        when(
          () => apiClient.post(
            any(),
            body: any(named: 'body'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Ops'));

        await expectLater(
          () => resource.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            deckId: 'deckId',
            userId: 'userId',
          ),
          throwsA(
            isA<ApiClientError>().having(
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

    group('connectToMatch', () {
      final connection = _MockConnection();
      setUp(() {
        when(
          () => apiClient.getWebsocketURI(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenReturn(Uri());

        when(
          () => webSocket.connection,
        ).thenAnswer((_) => connection);
      });

      test('Makes the correct call', () {
        when(
          () => connection.firstWhere(any()),
        ).thenAnswer((_) async => const Connected());

        resource.connectToMatch(matchId: '', isHost: true);
        verify(
          () => apiClient.getWebsocketURI(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('throws on error', () async {
        when(
          () => connection.firstWhere(any()),
        ).thenThrow(Exception('oops'));

        await expectLater(
          () => resource.connectToMatch(matchId: '', isHost: true),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'websocket matches/connect/ returned with the following error: "Exception: oops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
