// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

void main() {
  group('InitialsChanged', () {
    test('can be instantiated', () {
      expect(InitialsChanged(initials: 'ABC'), isNotNull);
    });

    test('supports equality', () {
      expect(
        InitialsChanged(initials: 'ABC'),
        equals(InitialsChanged(initials: 'ABC')),
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
