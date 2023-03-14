// ignore_for_file: prefer_const_constructors
import 'package:game_script_machine/game_script_machine.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:test/test.dart';

const script = '''
fun compareSuits(suitA, suitB) -> int {
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

fun compareCards(a, b) -> int {
  if (a > b) {
    return 1;
  } else if (a < b) {
    return -1;
  } else {
    return 0;
  }
}''';

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

    group('evalCardPower', () {
      test('correctly evaluates the values', () {
        expect(
          GameScriptMachine.initialize(script).evalCardPower(10, 5),
          equals(1),
        );

        expect(
          GameScriptMachine.initialize(script).evalCardPower(1, 5),
          equals(-1),
        );

        expect(
          GameScriptMachine.initialize(script).evalCardPower(5, 5),
          equals(0),
        );
      });
    });

    group('evalSuits', () {
      test('correctly evaluates the suits', () {
        final m = GameScriptMachine.initialize(script);
        expect(m.evalSuits('fire', 'air'), equals(1));
        expect(m.evalSuits('fire', 'metal'), equals(1));
        expect(m.evalSuits('fire', 'water'), equals(-1));
        expect(m.evalSuits('fire', 'earth'), equals(-1));
        expect(m.evalSuits('fire', 'fire'), equals(0));

        expect(m.evalSuits('air', 'water'), equals(1));
        expect(m.evalSuits('air', 'earth'), equals(1));
        expect(m.evalSuits('air', 'fire'), equals(-1));
        expect(m.evalSuits('air', 'metal'), equals(-1));
        expect(m.evalSuits('air', 'air'), equals(0));

        expect(m.evalSuits('metal', 'water'), equals(1));
        expect(m.evalSuits('metal', 'air'), equals(1));
        expect(m.evalSuits('metal', 'fire'), equals(-1));
        expect(m.evalSuits('metal', 'earth'), equals(-1));
        expect(m.evalSuits('metal', 'metal'), equals(0));

        expect(m.evalSuits('earth', 'fire'), equals(1));
        expect(m.evalSuits('earth', 'metal'), equals(1));
        expect(m.evalSuits('earth', 'water'), equals(-1));
        expect(m.evalSuits('earth', 'air'), equals(-1));
        expect(m.evalSuits('earth', 'earth'), equals(0));

        expect(m.evalSuits('water', 'fire'), equals(1));
        expect(m.evalSuits('water', 'earth'), equals(1));
        expect(m.evalSuits('water', 'metal'), equals(-1));
        expect(m.evalSuits('water', 'air'), equals(-1));
        expect(m.evalSuits('water', 'water'), equals(0));

        expect(m.evalSuits('invalid', 'invalid'), equals(0));
      });

      test('returns 0 when function not found', () {
        expect(
          GameScriptMachine.initialize('').evalSuits('fire', 'metal'),
          equals(0),
        );
      });

      test('throws error from function', () {
        const throwingScript = '''
fun compareSuits(suitA, suitB) -> int {
  throw 'error';
}''';
        expect(
          () => GameScriptMachine.initialize(throwingScript).evalSuits(
            'fire',
            'metal',
          ),
          throwsA(isA<HTError>()),
        );
      });
    });
  });
}
