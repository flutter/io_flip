import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jose/jose.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:jwt_middleware/src/jwt.dart';
import 'package:x509/x509.dart';

/// {@template gcloud_middleware}
/// A dart_frog middleware for checking JWT authorization for gcloud token.
/// {@endtemplate}
class GCloudMiddleware {
  /// {@macro gcloud_middleware}
  GCloudMiddleware({
    required String projectId,
    JwtParser parseJwt = JWT.from,
    JwsParser parseJws = JsonWebSignature.fromCompactSerialization,
    String? jwks,
    bool isEmulator = false,
  })  : _parseJwt = parseJwt,
        _parseJws = parseJws,
        _jwks = JsonWebKeyStore()..addKeySetUrl(Uri.parse(jwks ?? _jwksUrl)),
        _projectId = projectId,
        _isEmulator = isEmulator,
        _keys = const {};

  final JwtParser _parseJwt;
  final JwsParser _parseJws;
  final JsonWebKeyStore _jwks;
  final String _projectId;
  final bool _isEmulator;

  static const _keyUrl =
      'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com';
  static const _jwksUrl = 'https://firebaseappcheck.googleapis.com/v1/jwks';

  DateTime? _keyExpiration;
  Map<String, Verifier<PublicKey>> _keys;

  Middleware get middleware => (handler) {
        return (context) async {
          final authorization =
              context.request.headers['Authorization']?.split(' ');
          if (authorization != null &&
              authorization.length == 2 &&
              authorization.first == 'Bearer') {
            final token = authorization.last;

            if (await verifyToken(token)) {
              return handler(context);
            }
          }

          return Response(statusCode: HttpStatus.unauthorized);
        };
      };

  Future<bool> verifyToken(String token) async {
    final JWT jwt;
    try {
      jwt = JWT.from(token);
    } catch (e) {
      return false;
    }

    if (jwt.validateGcloudUser()) {
      return true;
    }

    return false;
  }
}
