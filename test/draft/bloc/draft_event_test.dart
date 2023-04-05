// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/draft/draft.dart';

void main() {
  group('DeckRequested', () {
    test('can be instantiated', () {
      expect(
        DeckRequested(Prompt()),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DeckRequested(Prompt()),
        equals(DeckRequested(Prompt())),
      );
    });
  });

  group('PreviousCard', () {
    test('can be instantiated', () {
      expect(
        PreviousCard(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        PreviousCard(),
        equals(PreviousCard()),
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

  group('CardSwiped', () {
    test('can be instantiated', () {
      expect(
        CardSwiped(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        CardSwiped(),
        equals(CardSwiped()),
      );
    });
  });

  group('CardSwipeStarted', () {
    test('can be instantiated', () {
      expect(
        CardSwipeStarted(0),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        CardSwipeStarted(.8),
        equals(CardSwipeStarted(.8)),
      );

      expect(
        CardSwipeStarted(.8),
        isNot(equals(CardSwipeStarted(.9))),
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
