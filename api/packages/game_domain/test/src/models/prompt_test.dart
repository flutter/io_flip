// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Prompt', () {
    test('can be instantiated', () {
      expect(
        Prompt(),
        isNotNull,
      );
    });

    test('Prompt correctly copies', () {
      const data1 = Prompt();
      final data2 = data1
          .copyWithNewAttribute('character')
          .copyWithNewAttribute('power')
          .copyWithNewAttribute('environment');

      expect(
        data2,
        equals(
          const Prompt(
            characterClass: 'character',
            power: 'power',
            secondaryPower: 'environment',
          ),
        ),
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Prompt(
          characterClass: 'character',
          power: 'power',
          secondaryPower: 'environment',
        ).toJson(),
        equals({
          'character': 'character',
          'power': 'power',
          'environment': 'environment',
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Prompt.fromJson(const {
          'character': 'character',
          'power': 'power',
          'environment': 'environment',
        }),
        equals(
          Prompt(
            characterClass: 'character',
            power: 'power',
            secondaryPower: 'environment',
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Prompt(
          characterClass: 'character',
          power: '',
          secondaryPower: '',
        ),
        equals(
          Prompt(
            characterClass: 'character',
            power: '',
            secondaryPower: '',
          ),
        ),
      );

      expect(
        Prompt(
          characterClass: '',
          power: 'power',
          secondaryPower: '',
        ),
        equals(
          Prompt(
            characterClass: '',
            power: 'power',
            secondaryPower: '',
          ),
        ),
      );

      expect(
        Prompt(
          characterClass: '',
          power: '',
          secondaryPower: 'environment',
        ),
        equals(
          Prompt(
            characterClass: '',
            power: '',
            secondaryPower: 'environment',
          ),
        ),
      );
    });
  });
}
