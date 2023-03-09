// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/match_making/match_making.dart';

void main() {
  group('MatchRequested', () {
    test('can be instantiated', () {
      expect(MatchRequested(), isNotNull);
    });

    test('supports equality', () {
      expect(MatchRequested(), equals(MatchRequested()));
    });
  });

  group('PrivateMatchRequested', () {
    test('can be instantiated', () {
      expect(PrivateMatchRequested(), isNotNull);
    });

    test('supports equality', () {
      expect(PrivateMatchRequested(), equals(PrivateMatchRequested()));
    });
  });

  group('GuestPrivateMatchRequested', () {
    test('can be instantiated', () {
      expect(GuestPrivateMatchRequested('a'), isNotNull);
    });

    test('supports equality', () {
      expect(
        GuestPrivateMatchRequested('a'),
        equals(
          GuestPrivateMatchRequested('a'),
        ),
      );

      expect(
        GuestPrivateMatchRequested('a'),
        isNot(
          equals(
            GuestPrivateMatchRequested('b'),
          ),
        ),
      );
    });
  });
}
