// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:jwt_middleware/src/authenticated_user.dart';
import 'package:jwt_middleware/src/jwt.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:x509/x509.dart';

// ignore: avoid_private_typedef_functions
typedef _UserGetter = AuthenticatedUser Function();

class _MockGet extends Mock {
  Future<http.Response> call(Uri uri);
}

class _MockJWT extends Mock implements JWT {}

class _MockRequestContext extends Mock implements RequestContext {}

class _FakeVerifier extends Fake implements Verifier {}

const _successfulKeyResponse = r'''
{
  "1e973ee0e16f7eef4f921d50dc61d70b2efefc19": "-----BEGIN CERTIFICATE-----\nMIIDHTCCAgWgAwIBAgIJAL5KzAr9wmGHMA0GCSqGSIb3DQEBBQUAMDExLzAtBgNV\nBAMMJnNlY3VyZXRva2VuLnN5c3RlbS5nc2VydmljZWFjY291bnQuY29tMB4XDTIz\nMDMxMTA5MzkyMloXDTIzMDMyNzIxNTQyMlowMTEvMC0GA1UEAwwmc2VjdXJldG9r\nZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wggEiMA0GCSqGSIb3DQEBAQUA\nA4IBDwAwggEKAoIBAQDB7l9kjFO2Qx9d+89V39UyIqalRJddcWn3kqgS8FZ4QkX5\nwL/aAMYa5rgURga51H0Q8Zm9Z+eLmGCothdaEu225md9JMYCW7PdLr6g5Ojigfnp\nslH0XoIgbPU1hSRCcyz5CzgBFWjhA8+j6q7ms5Annii6JV887aIAoKeE5IKrA+v9\ngXzC2rxcpjW8cVQORQOVSF3qKq635ynC2IrbMUE1iOPFthS7ONKkyhvYT+uAGiX0\nhtVoEkUf2k9EG1jPj/LQ2xlo/KGJcHdIFMlGgnCZahdhOVWBtcZ1hX/7TqeJwYo9\naHN/nIDQiayj6qy+V8lRVV7+5YZTGGstsOYe8o5vAgMBAAGjODA2MAwGA1UdEwEB\n/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMCMA0G\nCSqGSIb3DQEBBQUAA4IBAQBfnJjCwrBa7za107xZS3LD/fIfXuOFpuQirKlOJkLE\nUGbyF7dBDykoSDPe7s5xfUZtFnvu3xVfiFGkyA9lIs6dWw/Di9UdLLgfm2E+9vzH\n9XfU421zVMAQpO9AiMw3h5l2OZHk/+ae81OcyFlq1SphIVJOqwBNj8841RT6Ui9i\n8i//jLqMDx2i91lDBwHGNrXxaAMWD6dm8On9nKhEYs8dze2ge87P0P8nFEYDJUNQ\nFbA4TrqjbNtC3XuZHZpsUolKVs+q2+PavnMj/RRQegtLp9jTZq4M6iifrnqNbte9\nzbCArdgqFZyJKAvAnQlQ+XVNMf4bo/5Y55kMUlq/YQBt\n-----END CERTIFICATE-----\n",
  "58824a26f1ecd56127e89f5c90a8806112abe99c": "-----BEGIN CERTIFICATE-----\nMIIDHDCCAgSgAwIBAgIIRHktzRZ0tvgwDQYJKoZIhvcNAQEFBQAwMTEvMC0GA1UE\nAwwmc2VjdXJldG9rZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wHhcNMjMw\nMzAzMDkzOTIxWhcNMjMwMzE5MjE1NDIxWjAxMS8wLQYDVQQDDCZzZWN1cmV0b2tl\nbi5zeXN0ZW0uZ3NlcnZpY2VhY2NvdW50LmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD\nggEPADCCAQoCggEBAMX5e9QHV4Z/CKVkkMoGkyBUAPHSNLETHoE7jL0gF/rUHaBk\n/ZOxDvy3ksMPXH+sUqGN9dE8RFq1csnlr+5U00HBMmjd88F0v0nfOqD+H1b9lLhM\nXIcRhOTj3W9ZzD0mQPMNxJkFVgwVIw1Wg+lpAuqhQOjckGBf/tB1O2+T21Zqq2is\ngvaikWLJHeGhvmEEwwC/JcHufT62+EHVSFN+7CEH7rOLrEArBiNHNba9ljzk5fDC\nURse3NBtYtWZpmIq3oBsV7JIXDWOkQdg9TTeX6UmD6jkVHHYtJaoHH4RPvOAO2a8\nexxGZpW1KRMLZpAJyGJmjBT0R4jqw93QnBHylkMCAwEAAaM4MDYwDAYDVR0TAQH/\nBAIwADAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwIwDQYJ\nKoZIhvcNAQEFBQADggEBAB+B5DDL9P6UkhuNX642m2Biglk+mc2H1habovwm3oeT\nBkXNmhi+CuKPnkZyHvP0tnmxslB4xecg+CjTlRRqjt+mopqm/zwT0xagYkmCL3oC\nOGeLuOLRyFve9sghJi7xzGmT/gEIT3H5QmIwnq9xDxBG/iAqgy9PFFho78rz7Cdv\nmet/L5poV0y00NJ3SX6XxPvt+FBd8qyv1HxEV/RXFYJ4gNWVy6kEh/D9bvSgbvnh\n1LkJt+shUKrc+Ade2vrCq70MgA5199Vrt99aYy+TKakX8VAluyiiZplHpfQCxh//\nHl6FoA41EBwkroVue02YguO8efqFTwDnb0GsmHRPvg0=\n-----END CERTIFICATE-----\n"
}
''';

void main() {
  final unauthorizedResponse = isA<Response>().having(
    (r) => r.statusCode,
    'statusCode',
    HttpStatus.unauthorized,
  );

  final successfulReponse = isA<Response>().having(
    (r) => r.statusCode,
    'statusCode',
    HttpStatus.ok,
  );

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(_FakeVerifier());
  });

  group('JwtMiddleware', () {
    final uri = Uri.parse('https://example.com/api/endpoint');
    const projectId = 'PROJECT_ID';
    const keyId = '1e973ee0e16f7eef4f921d50dc61d70b2efefc19';
    const user = AuthenticatedUser('USER_ID');
    final returnsUser = isA<_UserGetter>().having(
      (f) => f(),
      'returns',
      user,
    );

    late GetCall get;
    late JWT jwt;
    late JwtMiddleware subject;
    late JwtParser parseJwt;
    late bool isEmulator;

    setUp(() {
      get = _MockGet().call;
      when(() => get(any())).thenAnswer(
        (_) async => http.Response(
          _successfulKeyResponse,
          200,
          headers: {
            'cache-control': 'public, max-age=3600, must-revalidate',
          },
        ),
      );

      jwt = _MockJWT();
      when(() => jwt.userId).thenReturn('USER_ID');
      when(() => jwt.validate(any())).thenReturn(true);
      when(() => jwt.keyId).thenReturn(keyId);
      when(() => jwt.verifyWith(any())).thenReturn(true);

      parseJwt = (_) => jwt;
      isEmulator = false;
    });

    Handler getHandler() {
      subject = JwtMiddleware(
        projectId: projectId,
        get: get,
        parseJwt: parseJwt,
        isEmulator: isEmulator,
      );
      return subject.middleware((_) async {
        return Response();
      });
    }

    group('request fails (401)', () {
      test('with no authorization header', () async {
        final handler = getHandler();
        final request = Request.get(uri);
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });

      test('without a valid token structure', () async {
        final handler = getHandler();
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'invalid',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });

      test('without a bearer token', () async {
        final handler = getHandler();
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });

      test('when parsing token fails', () async {
        parseJwt = (_) => throw Exception();
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        final handler = getHandler();
        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });

      test('when validating token fails', () async {
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        when(() => jwt.validate(projectId)).thenReturn(false);

        final handler = getHandler();
        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });

      test('when refreshing keys fails', () async {
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        when(() => get(any())).thenThrow(Exception());

        final handler = getHandler();
        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });

      test('when parsing keys fails', () async {
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);

        when(() => get(any())).thenAnswer(
          (_) async => http.Response(
            jsonEncode(
              {
                keyId: 'invalid',
              },
            ),
            200,
          ),
        );

        final handler = getHandler();
        final response = await handler(context);

        expect(response, unauthorizedResponse);
      });
    });

    group('request succeeds', () {
      test('when parsing token succeeds and isEmulator is true', () async {
        isEmulator = true;
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);
        when(() => context.provide<AuthenticatedUser>(any(that: returnsUser)))
            .thenReturn(context);

        final handler = getHandler();
        final response = await handler(context);

        expect(response, successfulReponse);
      });

      test('when validating and verifying token succeeds', () async {
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);
        when(() => context.provide<AuthenticatedUser>(any(that: returnsUser)))
            .thenReturn(context);

        final handler = getHandler();
        final response = await handler(context);

        expect(response, successfulReponse);
      });

      test('and does not update keys unnecessarily', () async {
        final request = Request.get(
          uri,
          headers: {
            'authorization': 'Bearer myToken',
          },
        );
        final context = _MockRequestContext();
        when(() => context.request).thenReturn(request);
        when(() => context.provide<AuthenticatedUser>(any(that: returnsUser)))
            .thenReturn(context);

        final handler = getHandler();
        final responses = [
          await handler(context),
          await handler(context),
          await handler(context),
        ];

        expect(responses, everyElement(successfulReponse));
        verify(() => get(any())).called(1);
      });

      test('and updates keys as needed', () async {
        var time = DateTime.now();
        final clock = Clock(() => time);

        await withClock(clock, () async {
          final request = Request.get(
            uri,
            headers: {
              'authorization': 'Bearer myToken',
            },
          );
          final context = _MockRequestContext();
          when(() => context.request).thenReturn(request);
          when(() => context.provide<AuthenticatedUser>(any(that: returnsUser)))
              .thenReturn(context);

          final handler = getHandler();
          final responses = [
            await handler(context),
            await handler(context),
          ];

          time = time.add(Duration(minutes: 61));
          final responses2 = [
            await handler(context),
            await handler(context),
          ];

          expect(responses, everyElement(successfulReponse));
          expect(responses2, everyElement(successfulReponse));
          verify(() => get(any())).called(2);
        });
      });
    });
  });
}
