import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

void main() {
  group('LeaderboardResource', () {
    late ApiClient apiClient;
    late http.Response response;
    late LeaderboardResource resource;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();

      resource = LeaderboardResource(apiClient: apiClient);
    });

    group('getLeaderboardResults', () {
      setUp(() {
        when(() => apiClient.get(any())).thenAnswer((_) async => response);
      });

      test('makes the correct call ', () async {
        const leaderboardPlayer = LeaderboardPlayer(
          id: 'id',
          longestStreak: 1,
          initials: 'TST',
        );

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode(
            {
              'leaderboardPlayers': [leaderboardPlayer.toJson()],
            },
          ),
        );

        final results = await resource.getLeaderboardResults();

        expect(results, equals([leaderboardPlayer]));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getLeaderboardResults,
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /leaderboard/results returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getLeaderboardResults,
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /leaderboard/results returned invalid response "Oops"',
              ),
            ),
          ),
        );
      });
    });

    group('getInitialsBlacklist', () {
      setUp(() {
        when(() => apiClient.get(any())).thenAnswer((_) async => response);
      });

      test('gets initials blacklist', () async {
        const blacklist = ['WTF'];

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'list': blacklist}));
        final result = await resource.getInitialsBlacklist();

        expect(result, equals(blacklist));
      });

      test('gets empty blacklist if endpoint not found', () async {
        const emptyList = <String>[];

        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        final result = await resource.getInitialsBlacklist();

        expect(result, equals(emptyList));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getInitialsBlacklist,
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /leaderboard/initials_blacklist returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getInitialsBlacklist,
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /leaderboard/initials_blacklist returned invalid response "Oops"',
              ),
            ),
          ),
        );
      });
    });

    group('addInitialsToScoreCard', () {
      const scoreCardId = 'scoreCardId';
      const initials = 'initials';

      setUp(() {
        when(() => apiClient.post(any(), body: any(named: 'body')))
            .thenAnswer((_) async => response);
      });

      test('makes the correct call', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        await resource.addInitialsToScoreCard(
          scoreCardId: scoreCardId,
          initials: initials,
        );

        verify(
          () => apiClient.post(
            '/game/leaderboard/initials',
            body: jsonEncode({
              'scoreCardId': scoreCardId,
              'initials': initials,
            }),
          ),
        ).called(1);
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          () => resource.addInitialsToScoreCard(
            scoreCardId: scoreCardId,
            initials: initials,
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /leaderboard/initials returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
