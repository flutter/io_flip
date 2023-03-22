// ignore_for_file: prefer_const_constructors

import 'package:encryption_middleware/encryption_middleware.dart';
import 'package:test/test.dart';

void main() {
  group('EncryptionMiddleware', () {
    test('can be instantiated', () {
      expect(EncryptionMiddleware(), isNotNull);
    });
  });
}
