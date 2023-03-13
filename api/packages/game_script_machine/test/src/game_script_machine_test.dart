// ignore_for_file: prefer_const_constructors
import 'package:game_script_machine/game_script_machine.dart';
import 'package:test/test.dart';

const script = '''
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

    test('returns the currentScript', () {
      expect(
        GameScriptMachine.initialize(script).currentScript,
        equals(script),
      );
    });
  });
}
