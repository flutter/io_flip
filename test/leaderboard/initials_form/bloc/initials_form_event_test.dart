// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

void main() {
  group('MatchRequested', () {
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
}
