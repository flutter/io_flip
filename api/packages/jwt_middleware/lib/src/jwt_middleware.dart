import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:jwt_middleware/src/authenticated_user.dart';
import 'package:jwt_middleware/src/jwt.dart';
import 'package:x509/x509.dart';

/// Definition of an HTTP GET call used by this client.
typedef GetCall = Future<http.Response> Function(Uri uri);

/// Definition of a function for parsing encoded JWTs.
typedef JwtParser = JWT Function(String token);

/// Definition of a function for parsing JWS.
typedef JwsParser = JsonWebSignature Function(String);

/// {@template jwt_middleware}
/// A dart_frog middleware for checking JWT authorization.
/// {@endtemplate}
class JwtMiddleware {
  /// {@macro jwt_middleware}
  JwtMiddleware({
    required String projectId,
    GetCall get = http.get,
    JwtParser parseJwt = JWT.from,
    JwsParser parseJws = JsonWebSignature.fromCompactSerialization,
    DefaultJsonWebKeySetLoader? jwksLoader,
    bool isEmulator = false,
  })  : _get = get,
        _parseJwt = parseJwt,
        _parseJws = parseJws,
        _jwksLoader = jwksLoader ?? DefaultJsonWebKeySetLoader(),
        _projectId = projectId,
        _isEmulator = isEmulator,
        _keys = const {};

  final GetCall _get;
  final JwtParser _parseJwt;
  final JwsParser _parseJws;
  final DefaultJsonWebKeySetLoader _jwksLoader;
  final String _projectId;
  final bool _isEmulator;

  static const _keyUrl =
      'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com';
  static const _jwksUrl = 'https://firebaseappcheck.googleapis.com/v1/jwks';

  DateTime? _keyExpiration;
  Map<String, Verifier<PublicKey>> _keys;

  /// The middleware function used by dart_frog.
  Middleware get middleware => (handler) {
        return (context) async {
          final authorization =
              context.request.headers['Authorization']?.split(' ');
          if (authorization != null &&
              authorization.length == 2 &&
              authorization.first == 'Bearer') {
            final token = authorization.last;

            final userId = await verifyToken(token);
            if (userId != null && await verifyAppCheckToken(context)) {
              return handler(context.provide(() => AuthenticatedUser(userId)));
            }
          }

          return Response(statusCode: HttpStatus.unauthorized);
        };
      };

  /// Verifies the app check token in the given request context.
  Future<bool> verifyAppCheckToken(RequestContext context) async {
    final appCheckToken = context.request.headers['X-Firebase-AppCheck'];
    if (appCheckToken == null || appCheckToken.isEmpty) return false;
    if (_isEmulator) return true;

    try {
      final jwks = await _jwksLoader.read(Uri.parse(_jwksUrl));

      final jws = _parseJws(appCheckToken);
      final keyId = jws.commonHeader.keyId;
      final jwk = jwks.keys.firstWhere((key) => key.keyId == keyId);
      final keyStore = JsonWebKeyStore()..addKey(jwk);

      return jws.verify(keyStore);
    } catch (e) {
      return false;
    }
  }

  /// Verifies the given token and returns the user id if valid.
  Future<String?> verifyToken(String token) async {
    final JWT jwt;
    try {
      jwt = _parseJwt(token);
    } catch (e) {
      return null;
    }

    if (_isEmulator) {
      return jwt.userId;
    }

    if (jwt.validate(_projectId)) {
      final keyId = jwt.keyId;
      if (keyId != null) {
        final verifier = await _getVerifier(keyId);
        if (verifier != null && jwt.verifyWith(verifier)) {
          return jwt.userId;
        }
      }
    }

    return null;
  }

  Future<Verifier<PublicKey>?> _getVerifier(String kid) async {
    if (_keyExpiration == null || _keyExpiration!.isBefore(clock.now())) {
      try {
        await _refreshKeys();
      } catch (e) {
        return null;
      }
    }

    return _keys[kid];
  }

  Future<void> _refreshKeys() async {
    final response = await _get(Uri.parse(_keyUrl));
    if (response.statusCode == HttpStatus.ok) {
      final pems = Map<String, String>.from(jsonDecode(response.body) as Map);
      _keys = {
        for (final entry in pems.entries)
          entry.key: (parsePem(entry.value).first as X509Certificate)
              .publicKey
              .createVerifier(algorithms.signing.rsa.sha256),
      };
      final maxAgeMatch = RegExp(r'max-age=(\d+)').firstMatch(
        response.headers['cache-control'] ?? '',
      );
      final maxAge = int.tryParse(maxAgeMatch?.group(1) ?? '0');
      _keyExpiration = clock.now().add(Duration(seconds: maxAge ?? 0));
    }
  }
}
