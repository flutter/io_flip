import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('supports value equality', () {
      const userA = User(id: 'A');
      const secondUserA = User(id: 'A');
      const userB = User(id: 'B');

      expect(userA, equals(secondUserA));
      expect(userA, isNot(equals(userB)));
    });
  });
}
