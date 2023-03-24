import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
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
  });
}
