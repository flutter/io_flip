// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/match_making/match_making.dart';

void main() {
  group('MatchMakingEvent', () {
    test('can be instantiated', () {
      expect(MatchRequested(), isNotNull);
    });

    test('supports equality', () {
      expect(MatchRequested(), equals(MatchRequested()));
    });
  });
}
