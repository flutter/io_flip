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
          ),
        ),
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Prompt(
          characterClass: 'characterClass',
          power: 'power',
        ).toJson(),
        equals({
          'characterClass': 'characterClass',
          'power': 'power',
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Prompt.fromJson(const {
          'characterClass': 'characterClass',
          'power': 'power',
        }),
        equals(
          Prompt(
            characterClass: 'characterClass',
            power: 'power',
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Prompt(
          characterClass: 'characterClass',
          power: '',
        ),
        equals(
          Prompt(
            characterClass: 'characterClass',
            power: '',
          ),
        ),
      );

      expect(
        Prompt(
          characterClass: '',
          power: 'power',
        ),
        equals(
          Prompt(
            characterClass: '',
            power: 'power',
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
