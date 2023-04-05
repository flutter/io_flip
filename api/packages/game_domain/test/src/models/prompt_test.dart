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
            character: 'character',
            power: 'power',
            environment: 'environment',
          ),
        ),
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Prompt(
          character: 'character',
          power: 'power',
          environment: 'environment',
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
            character: 'character',
            power: 'power',
            environment: 'environment',
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Prompt(
          character: 'character',
          power: '',
          environment: '',
        ),
        equals(
          Prompt(
            character: 'character',
            power: '',
            environment: '',
          ),
        ),
      );

      expect(
        Prompt(
          character: '',
          power: 'power',
          environment: '',
        ),
        equals(
          Prompt(
            character: '',
            power: 'power',
            environment: '',
          ),
        ),
      );

      expect(
        Prompt(
          character: '',
          power: '',
          environment: 'environment',
        ),
        equals(
          Prompt(
            character: '',
            power: '',
            environment: 'environment',
          ),
        ),
      );
    });
  });
}
