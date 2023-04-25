// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

void main() {
  group('InitialsChanged', () {
    test('can be instantiated', () {
      expect(InitialsChanged(index: 0, initial: 'ABC'), isNotNull);
    });

    test('supports equality', () {
      expect(
        InitialsChanged(index: 0, initial: 'ABC'),
        equals(InitialsChanged(index: 0, initial: 'ABC')),
      );
    });
  });

  group('InitialsSubmitted', () {
    test('can be instantiated', () {
      expect(InitialsSubmitted(), isNotNull);
    });

    test('supports equality', () {
      expect(
        InitialsSubmitted(),
        equals(InitialsSubmitted()),
      );
    });
  });
}
