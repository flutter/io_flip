import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:encrypt/encrypt.dart';

/// {@template encryption_middleware}
/// A dart_frog middleware for encrypting responses.
/// {@endtemplate}
class EncryptionMiddleware {
  /// {@macro encryption_middleware}
  const EncryptionMiddleware({
    String? key,
    String? iv,
  })  : _key = key,
        _iv = iv;

  final String? _key;
  final String? _iv;

  /// The middleware function used by dart_frog.
  Middleware get middleware => (handler) {
        return (context) async {
          final response = await handler(context);
          if (response.statusCode == 500) {
            return response;
          }
          final body = await response.body();

          if (body.isEmpty) {
            return response.copyWith(body: body);
          }

          final key = Key.fromUtf8(_key ?? _encryptionKey);
          final iv = IV.fromUtf8(_iv ?? _encryptionIV);
          final encrypter = Encrypter(AES(key));

          final encrypted = encrypter.encrypt(jsonEncode(body), iv: iv).base64;

          return response.copyWith(body: encrypted);
        };
      };
}

String get _encryptionKey {
  final value = Platform.environment['ENCRYPTION_KEY'];
  if (value == null) {
    throw ArgumentError('ENCRYPTION_KEY is required to run the API');
  }
  return value;
}

String get _encryptionIV {
  final value = Platform.environment['ENCRYPTION_IV'];
  if (value == null) {
    throw ArgumentError('ENCRYPTION_IV is required to run the API');
  }
  return value;
}
