import 'dart:async';
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

      resource = GameResource(
        apiClient: apiClient,
        webSocketTimeout: const Duration(milliseconds: 10),
      );
    });

    group('generateCard', () {
      setUp(() {
        when(
          () => apiClient.post(any()),
        ).thenAnswer((_) async => response);
      });

      test('returns a Card', () async {
        final cards = List.generate(
          10,
          (_) => const Card(
            id: '',
            name: 'Dash',
            description: 'Cute blue bird',
            image: 'image.png',
            rarity: true,
            power: 1,
            suit: Suit.air,
          ),
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({'cards': cards.map((e) => e.toJson()).toList()}),
        );
        final returnedCards = await resource.generateCards(const Prompt());

        expect(returnedCards, equals(cards));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          resource.generateCards(const Prompt()),
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
          resource.generateCards(const Prompt()),
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
      setUp(() {
        when(
          () => apiClient.post(any(), body: any(named: 'body')),
        ).thenAnswer((_) async => response);
      });

      test('returns the deck id', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'id': 'deck'}));

        final id = await resource.createDeck(['a', 'b', 'c']);

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
          () => resource.createDeck(['a', 'b', 'c']),
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
          () => resource.createDeck(['a', 'b', 'c']),
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
      setUp(() {
        when(
          () => apiClient.get(any()),
        ).thenAnswer((_) async => response);
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
      setUp(() {
        when(
          () => apiClient.get(any()),
        ).thenAnswer((_) async => response);
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
      setUp(() {
        when(
          () => apiClient.get(any()),
        ).thenAnswer((_) async => response);
      });

      test('returns a match state', () async {
        const matchState = MatchState(
          id: 'matchStateId',
          matchId: 'matchId',
          guestPlayedCards: ['a'],
          hostPlayedCards: ['b'],
          hostStartsMatch: true,
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
      setUp(() {
        when(
          () => apiClient.post(any()),
        ).thenAnswer((_) async => response);
      });

      test('makes the correct call', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        await resource.playCard(
          matchId: 'matchId',
          cardId: 'cardId',
          deckId: 'deckId',
        );

        verify(
          () => apiClient.post(
            '/game/matches/matchId/decks/deckId/cards/cardId',
          ),
        ).called(1);
      });

      test('throws an ApiClientError when the request fails', () async {
        when(
          () => apiClient.post(
            any(),
            body: any(named: 'body'),
          ),
        ).thenThrow(Exception('Ops'));

        await expectLater(
          () => resource.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            deckId: 'deckId',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/decks/deckId/cards/cardId failed with the following message: "Exception: Ops"',
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
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/decks/deckId/cards/cardId returned status 500 with the following response: "Ops"',
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
          ),
        ).thenThrow(Exception('Ops'));

        await expectLater(
          () => resource.playCard(
            matchId: 'matchId',
            cardId: 'cardId',
            deckId: 'deckId',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /matches/matchId/decks/deckId/cards/cardId failed with the following message: "Exception: Ops"',
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
          () => apiClient.connect(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => webSocket);

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
          () => apiClient.connect(
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
          throwsA(isA<ApiClientError>()),
        );
      });

      test('throws on error on timeout', () async {
        when(
          () => apiClient.connect(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => webSocket);

        when(
          () => webSocket.connection,
        ).thenAnswer((_) => connection);
        when(
          () => connection.firstWhere(any()),
        ).thenAnswer((_) async {
          return Future.delayed(const Duration(seconds: 3), () {
            return const Connecting();
          });
        });

        expect(
          () => resource.connectToMatch(matchId: '', isHost: true),
          throwsA(isA<ApiClientError>()),
        );
      });
    });

    group('connectToCpuMatch', () {
      test('Makes the correct call', () {
        when(
          () => apiClient.post(any()),
        ).thenAnswer((_) async => response);
        const matchId = 'matchId';
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        resource.connectToCpuMatch(matchId: matchId);

        verify(
          () => apiClient.post(
            '/game/matches/$matchId/connect',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('Answers with error', () async {
        when(
          () => apiClient.post(any()),
        ).thenAnswer((_) async => response);
        when(() => response.body).thenReturn('Ops');

        when(() => response.statusCode).thenReturn(HttpStatus.methodNotAllowed);

        await expectLater(
          resource.connectToCpuMatch(matchId: ''),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              contains(
                'POST game/matches/connect returned status ${HttpStatus.methodNotAllowed}',
              ),
            ),
          ),
        );
      });

      test('Catches error', () async {
        when(
          () => apiClient.post(any()),
        ).thenThrow(Exception('oops'));

        await expectLater(
          resource.connectToCpuMatch(matchId: ''),
          throwsA(
            isA<ApiClientError>(),
          ),
        );
      });
    });
  });
}
