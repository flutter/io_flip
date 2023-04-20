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
    bool isEmulator = false,
  })  : _parseJwt = parseJwt,
        _projectId = projectId,
        _isEmulator = isEmulator;

  final JwtParser _parseJwt;
  final String _projectId;
  final bool _isEmulator;

  /// The middleware function used by dart_frog.
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

  /// Verifies the given token and returns true if valid.
  Future<bool> verifyToken(String token) async {
    final JWT jwt;
    try {
      jwt = _parseJwt(token);
    } catch (e) {
      return false;
    }

    if (_isEmulator || jwt.validateGcloudUser(_projectId)) {
      return true;
    }

    return false;
  }
}
