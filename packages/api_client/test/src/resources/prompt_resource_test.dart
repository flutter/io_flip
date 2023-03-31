import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
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

    group('getPromptWhitelist', () {
      setUp(() {
        when(() => apiClient.get(any())).thenAnswer((_) async => response);
      });

      test('gets whitelist', () async {
        const whitelist = ['WTF'];

        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'list': whitelist}));
        final result = await resource.getPromptWhitelist();

        expect(result, equals(whitelist));
      });

      test('gets empty whitelist if endpoint not found', () async {
        const emptyList = <String>[];

        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        final result = await resource.getPromptWhitelist();

        expect(result, equals(emptyList));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getPromptWhitelist(),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /prompt/whitelist returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when request response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getPromptWhitelist(),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /prompt/whitelist returned invalid response "Oops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
