import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

void main() {
  group('ScriptsResource', () {
    late ApiClient apiClient;
    late http.Response response;
    late ScriptsResource resource;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();

      when(() => apiClient.get(any())).thenAnswer((_) async => response);
      when(
        () => apiClient.put(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      resource = ScriptsResource(apiClient: apiClient);
    });

    group('getCurrentScript', () {
      test('returns the script', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('script');
        final returnedScript = await resource.getCurrentScript();

        expect(returnedScript, equals('script'));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          resource.getCurrentScript,
          throwsA(
            isA<ApiClientError>().having(
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
      test('send the correct request', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);
        await resource.updateScript('current', 'script');

        verify(
          () => apiClient.put('/scripts/current', body: 'script'),
        );
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          () => resource.updateScript('current', 'script'),
          throwsA(
            isA<ApiClientError>().having(
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
  });
}
