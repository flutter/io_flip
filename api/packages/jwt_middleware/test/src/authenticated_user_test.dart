// ignore_for_file: prefer_const_constructors

import 'package:jwt_middleware/src/authenticated_user.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticatedUser', () {
    test('uses value equality', () {
      final a = AuthenticatedUser('id');
      final b = AuthenticatedUser('id');
      final c = AuthenticatedUser('other');

      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
