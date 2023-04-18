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
          .copyWithNewAttribute('characterClass')
          .copyWithNewAttribute('power')
          .copyWithNewAttribute('secondaryPower');

      expect(
        data2,
        equals(
          const Prompt(
            characterClass: 'characterClass',
            power: 'power',
            secondaryPower: 'secondaryPower',
          ),
        ),
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Prompt(
          characterClass: 'characterClass',
          power: 'power',
          secondaryPower: 'secondaryPower',
        ).toJson(),
        equals({
          'characterClass': 'characterClass',
          'power': 'power',
          'secondaryPower': 'secondaryPower',
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Prompt.fromJson(const {
          'characterClass': 'characterClass',
          'power': 'power',
          'secondaryPower': 'secondaryPower',
        }),
        equals(
          Prompt(
            characterClass: 'characterClass',
            power: 'power',
            secondaryPower: 'secondaryPower',
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Prompt(
          characterClass: 'characterClass',
          power: '',
          secondaryPower: '',
        ),
        equals(
          Prompt(
            characterClass: 'characterClass',
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
          secondaryPower: 'secondaryPower',
        ),
        equals(
          Prompt(
            characterClass: '',
            power: '',
            secondaryPower: 'secondaryPower',
          ),
        ),
      );
    });

    test('sets intro seen', () {
      final prompt = Prompt();
      expect(
        prompt.setIntroSeen(),
        equals(Prompt(isIntroSeen: true)),
      );
    });
  });
}
