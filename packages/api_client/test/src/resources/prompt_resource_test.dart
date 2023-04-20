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
  group('PromptResource', () {
    late ApiClient apiClient;
    late http.Response response;
    late PromptResource resource;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();

      resource = PromptResource(apiClient: apiClient);
    });

    group('getPromptTerms', () {
      setUp(() {
        when(
          () => apiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);
      });

      test('gets correct list', () async {
        const powersList = ['Scientist'];

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'list': powersList}));
        final result = await resource.getPromptTerms(PromptTermType.power);

        expect(result, equals(powersList));
      });

      test('gets empty list if endpoint not found', () async {
        const emptyList = <String>[];

        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        final result = await resource.getPromptTerms(PromptTermType.power);

        expect(result, equals(emptyList));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getPromptTerms(PromptTermType.power),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /prompt/terms returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getPromptTerms(PromptTermType.power),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /prompt/terms returned invalid response "Oops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
