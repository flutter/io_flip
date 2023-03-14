// ignore_for_file: prefer_const_constructors
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:test/test.dart';

const script = '''
fun compareCards(valueA: int, valueB: int, suitA: str, suitB: str) -> int {
  var evaluation = compareSuits(suitA, suitB);
  if (evaluation == 0) {
    evaluation = compareValues(valueA, valueB);
  }
  return evaluation;
}

fun compareSuits(suitA: str, suitB: str) -> int {
  when (suitA) {
    'fire' -> {
      when (suitB) {
        'air', 'metal' -> return 1;
        'water', 'earth' -> return -1;
        else -> return 0;
      }
    }
    'air' -> {
      when (suitB) {
        'water', 'earth' -> return 1;
        'fire', 'metal' -> return -1;
        else -> return 0;
      }
    }
    'metal' -> {
      when (suitB) {
        'water', 'air' -> return 1;
        'fire', 'earth' -> return -1;
        else -> return 0;
      }
    }
    'earth' -> {
      when (suitB) {
        'fire', 'metal' -> return 1;
        'water', 'air' -> return -1;
        else -> return 0;
      }
    }
    'water' -> {
      when (suitB) {
        'fire', 'earth' -> return 1;
        'metal', 'air' -> return -1;
        else -> return 0;
      }
    }
    else -> return 0;
  }
}

fun compareValues(a: int, b: int) -> int {
  if (a > b) {
    return 1;
  } else if (a < b) {
    return -1;
  } else {
    return 0;
  }
}''';

Card _makeCard(Suit suit, [int power = 0]) => Card(
      id: 'id',
      name: 'name',
      description: 'description',
      image: 'image',
      power: power,
      rarity: false,
      suit: suit,
    );

void main() {
  group('GameScriptMachine', () {
    test('can be instantiated', () {
      expect(GameScriptMachine.initialize(script), isNotNull);
    });

    test('returns the currentScript', () {
      expect(
        GameScriptMachine.initialize(script).currentScript,
        equals(script),
      );
    });

    group('compare', () {
      test('correctly evaluates the result for different suits', () {
        final m = GameScriptMachine.initialize(script);

        // All the possible pairs of suits, where the first item wins.
        final pairs = [
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

        for (final pair in pairs) {
          final a = _makeCard(pair[0]);
          final b = _makeCard(pair[1]);
          expect(m.compare(a, b), equals(1));
          expect(m.compare(b, a), equals(-1));
        }
      });

      test('correctly evaluates the result for the same suit and value', () {
        final m = GameScriptMachine.initialize(script);

        for (final suit in Suit.values) {
          final a = _makeCard(suit);
          final b = _makeCard(suit);
          expect(m.compare(a, b), equals(0));
          expect(m.compare(b, a), equals(0));
        }
      });

      test(
        'correctly evaluates the result for the same suit and different values',
        () {
          final m = GameScriptMachine.initialize(script);

          for (final suit in Suit.values) {
            final a = _makeCard(suit, 10);
            final b = _makeCard(suit, 3);
            expect(m.compare(a, b), equals(1));
            expect(m.compare(b, a), equals(-1));
          }
        },
      );
    });
  });
}
