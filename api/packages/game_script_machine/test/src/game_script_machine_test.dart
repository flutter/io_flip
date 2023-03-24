// ignore_for_file: prefer_const_constructors
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:test/test.dart';

Card _makeCard(Suit suit, [int power = 0]) => Card(
      id: 'id',
      name: 'name',
      description: 'description',
      image: 'image',
      power: power,
      rarity: false,
      suit: suit,
    );
// All the possible pairs of suits, where the first item wins.
const pairs = [
  [Suit.fire, Suit.air],
  [Suit.fire, Suit.metal],
  [Suit.air, Suit.water],
  [Suit.air, Suit.earth],
  [Suit.metal, Suit.water],
  [Suit.metal, Suit.air],
  [Suit.earth, Suit.fire],
  [Suit.earth, Suit.metal],
  [Suit.water, Suit.fire],
  [Suit.water, Suit.earth],
];

void main() {
  group('GameScriptMachine', () {
    test('can be instantiated', () {
      expect(GameScriptMachine.initialize(defaultGameLogic), isNotNull);
    });

    test('returns the currentScript', () {
      expect(
        GameScriptMachine.initialize(defaultGameLogic).currentScript,
        equals(defaultGameLogic),
      );
    });

    group('compare', () {
      test('correctly evaluates the result for different suits', () {
        final m = GameScriptMachine.initialize(defaultGameLogic);

        for (final pair in pairs) {
          final a = pair[0];
          final b = pair[1];
          expect(m.compareSuits(a, b), equals(1));
          expect(m.compareSuits(b, a), equals(-1));
        }
      });

      test('correctly evaluates the result for the same suit and value', () {
        final m = GameScriptMachine.initialize(defaultGameLogic);

        for (final suit in Suit.values) {
          final a = _makeCard(suit);
          final b = _makeCard(suit);
          expect(m.compare(a, b), equals(0));
          expect(m.compare(b, a), equals(0));
        }
      });

      test(
        'correctly evaluates the result for the same suit and different values '
        'when winning suit has higher value',
        () {
          final m = GameScriptMachine.initialize(defaultGameLogic);

          for (final suit in Suit.values) {
            final a = _makeCard(suit, 10);
            final b = _makeCard(suit, 3);
            expect(m.compare(a, b), equals(1));
            expect(m.compare(b, a), equals(-1));
          }
        },
      );

      test(
        'correctly evaluates the result for different suits and different '
        'values when winning suit has the lower value but modifier is not '
        'enough',
        () {
          final m = GameScriptMachine.initialize(defaultGameLogic);

          for (final pair in pairs) {
            final aSuit = pair[0];
            final bSuit = pair[1];
            final a = _makeCard(aSuit, 10);
            final b = _makeCard(bSuit, 22);
            expect(m.compare(a, b), equals(-1));
            expect(m.compare(b, a), equals(1));
          }
        },
      );

      test(
        'correctly evaluates the result for different suits and different '
        'values when winning suit has the lower value and the notfier is '
        'enough',
        () {
          final m = GameScriptMachine.initialize(defaultGameLogic);

          for (final pair in pairs) {
            final aSuit = pair[0];
            final bSuit = pair[1];
            final a = _makeCard(aSuit, 19);
            final b = _makeCard(bSuit, 20);
            expect(m.compare(a, b), equals(1));
            expect(m.compare(b, a), equals(-1));
          }
        },
      );
    });
  });
}
