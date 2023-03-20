import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:jwt_middleware/src/jwt.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:x509/x509.dart';

class _MockVerifier extends Mock implements Verifier<PublicKey> {}

void main() {
  const validToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjFlOTczZWUwZTE2ZjdlZWY0ZjkyM'
      'WQ1MGRjNjFkNzBiMmVmZWZjMTkiLCJ0eXAiOiJKV1QifQ.eyJwcm92aWRlcl9pZCI6ImFub2'
      '55bW91cyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS90b3AtZGFzaC'
      '1kZXYiLCJhdWQiOiJ0b3AtZGFzaC1kZXYiLCJhdXRoX3RpbWUiOjE2NzkwNjUwNTEsInVzZX'
      'JfaWQiOiJVUHlnNURKWHFuTmw0OWQ0YUJKV1Z6dmFKeDEyIiwic3ViIjoiVVB5ZzVESlhxbk'
      '5sNDlkNGFCSldWenZhSngxMiIsImlhdCI6MTY3OTA2NTA1MiwiZXhwIjoxNjc5MDY4NjUyLC'
      'JmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7fSwic2lnbl9pbl9wcm92aWRlciI6ImFub255bW'
      '91cyJ9fQ.v0DpGE7mKOwg4S6TbG_xxy5Spnfvb_Bdh7c_A_iW8RBPwt_XtN-3XK7h6Rv8-Z6'
      '5nkYIuLugJZTuC5rSnnwxb6Kn_p2lhYJZY5c1OdK9EvCfA47E3CIL621ujxcKGHOOUjJUZTr'
      '9dd8g0-FDagc0GbYFrGVRvwe5gcEDxRrAOMsbZoJ3D3IJAIiDTYFrQSAyF8LY_Cy6hMrBvdv'
      'cpt29UML0rjcWdU5gB6u80rjOg_cgo5y3eWZOsOrYnKQd8iarrKDXFGRzPLgfDWEKJcRduXv'
      'H_wIKqaprx2eK3FXiCDfhZDbwANzrfiVuI2HUcrqtdx78ylXTMMWPv4GNqJDodw';
  const noSignatureToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjFlOTczZWUwZTE2ZjdlZWY0ZjkyM'
      'WQ1MGRjNjFkNzBiMmVmZWZjMTkiLCJ0eXAiOiJKV1QifQ.eyJwcm92aWRlcl9pZCI6ImFub2'
      '55bW91cyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS90b3AtZGFzaC'
      '1kZXYiLCJhdWQiOiJ0b3AtZGFzaC1kZXYiLCJhdXRoX3RpbWUiOjE2NzkwNjUwNTEsInVzZX'
      'JfaWQiOiJVUHlnNURKWHFuTmw0OWQ0YUJKV1Z6dmFKeDEyIiwic3ViIjoiVVB5ZzVESlhxbk'
      '5sNDlkNGFCSldWenZhSngxMiIsImlhdCI6MTY3OTA2NTA1MiwiZXhwIjoxNjc5MDY4NjUyLC'
      'JmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7fSwic2lnbl9pbl9wcm92aWRlciI6ImFub255bW'
      '91cyJ9fQ.';

  group('JWT', () {
    final body = Uint8List(4);
    final signature = Signature(Uint8List(8));
    const nowSeconds = 1679079237;
    const projectId = 'PROJECT_ID';
    final now = DateTime.fromMillisecondsSinceEpoch(nowSeconds * 1000);
    final clock = Clock.fixed(now);

    JWT buildSubject({
      String? alg = 'RS256',
      int? exp = nowSeconds + 10800,
      int? iat = nowSeconds - 60,
      String? aud = projectId,
      String? iss = 'https://securetoken.google.com/$projectId',
      String? sub = 'userId',
      int? authTime = nowSeconds - 60,
      String? userId = 'userId',
      String? kid = '1e973ee0e16f7eef4f921d50dc61d70b2efefc19',
    }) =>
        JWT(
          body: body,
          signature: signature,
          payload: {
            'exp': exp,
            'iat': iat,
            'aud': aud,
            'iss': iss,
            'sub': sub,
            'auth_time': authTime,
            'user_id': userId,
          },
          header: {
            'alg': alg,
            'kid': kid,
          },
        );

    group('from', () {
      test('parses a valid token', () {
        final jwt = JWT.from(validToken);
        expect(jwt.keyId, equals('1e973ee0e16f7eef4f921d50dc61d70b2efefc19'));
        expect(jwt.userId, equals('UPyg5DJXqnNl49d4aBJWVzvaJx12'));
      });

      test('parses a token without a signature', () {
        final jwt = JWT.from(noSignatureToken);
        expect(jwt.keyId, equals('1e973ee0e16f7eef4f921d50dc61d70b2efefc19'));
        expect(jwt.userId, equals('UPyg5DJXqnNl49d4aBJWVzvaJx12'));
      });
    });

    group('userId', () {
      test('returns the user id', () {
        final jwt = buildSubject();
        expect(jwt.userId, equals('userId'));
      });

      test('returns null when the user id is not in the payload', () {
        final jwt = buildSubject(userId: null);
        expect(jwt.userId, isNull);
      });
    });

    group('keyId', () {
      test('returns the key id', () {
        final jwt = buildSubject();
        expect(jwt.keyId, equals('1e973ee0e16f7eef4f921d50dc61d70b2efefc19'));
      });

      test('returns null when the key id is not in the header', () {
        final jwt = buildSubject(kid: null);
        expect(jwt.keyId, isNull);
      });
    });

    group('verifyWith', () {
      test('uses the verifier to verify the signature', () {
        final jwt = buildSubject();
        final verifier = _MockVerifier();
        when(() => verifier.verify(body, signature)).thenReturn(true);
        final result = jwt.verifyWith(verifier);
        expect(result, isTrue);
        verify(() => verifier.verify(body, signature)).called(1);
      });

      test('returns false when there is no signature', () {
        final jwt = JWT.from(noSignatureToken);
        final verifier = _MockVerifier();
        final result = jwt.verifyWith(verifier);
        expect(result, isFalse);
      });
    });

    group('validate', () {
      test(
        'returns true when valid',
        () => withClock(clock, () {
          final jwt = buildSubject();
          expect(jwt.validate(projectId), isTrue);
        }),
      );

      group('returns false', () {
        test('when alg is not RS256', () {
          final jwt = buildSubject(alg: 'invalid');
          expect(jwt.validate(projectId), isFalse);
        });

        test('when exp is null', () {
          final jwt = buildSubject(exp: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test('when iat is null', () {
          final jwt = buildSubject(iat: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test('when aud is null', () {
          final jwt = buildSubject(aud: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test('when iss is null', () {
          final jwt = buildSubject(iss: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test('when sub is null', () {
          final jwt = buildSubject(sub: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test('when auth_time is null', () {
          final jwt = buildSubject(authTime: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test('when user_id is null', () {
          final jwt = buildSubject(userId: null);
          expect(jwt.validate(projectId), isFalse);
        });

        test(
          'when exp is in the past',
          () => withClock(clock, () {
            final jwt = buildSubject(exp: nowSeconds - 1);
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when exp is current',
          () => withClock(clock, () {
            final jwt = buildSubject(exp: nowSeconds);
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when iat is in the future',
          () => withClock(clock, () {
            final jwt = buildSubject(iat: nowSeconds + 1);
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when iat is current',
          () => withClock(clock, () {
            final jwt = buildSubject(iat: nowSeconds);
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when auth_time is in the future',
          () => withClock(clock, () {
            final jwt = buildSubject(authTime: nowSeconds + 1);
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when auth_time is current',
          () => withClock(clock, () {
            final jwt = buildSubject(authTime: nowSeconds);
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when aud is not the project id',
          () => withClock(clock, () {
            final jwt = buildSubject(aud: 'invalid');
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when iss is not the expected url',
          () => withClock(clock, () {
            final jwt = buildSubject(iss: 'invalid');
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when sub is not the user id',
          () => withClock(clock, () {
            final jwt = buildSubject(sub: 'invalid');
            expect(jwt.validate(projectId), isFalse);
          }),
        );

        test(
          'when user_id is not the user id',
          () => withClock(clock, () {
            final jwt = buildSubject(userId: 'invalid');
            expect(jwt.validate(projectId), isFalse);
          }),
        );
      });
    });
  });
}
