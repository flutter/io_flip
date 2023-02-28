// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/draft/draft.dart';

void main() {
  group('DeckRequested', () {
    test('can be instantiated', () {
      expect(
        DeckRequested(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DeckRequested(),
        equals(DeckRequested()),
      );
    });
  });

  group('NextCard', () {
    test('can be instantiated', () {
      expect(
        NextCard(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        NextCard(),
        equals(NextCard()),
      );
    });
  });

  group('SelectCard', () {
    test('can be instantiated', () {
      expect(
        SelectCard(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        SelectCard(),
        equals(SelectCard()),
      );
    });
  });
}
