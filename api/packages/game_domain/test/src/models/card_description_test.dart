// ignore_for_file: prefer_const_constructors

import 'package:game_domain/src/models/card_description.dart';
import 'package:test/test.dart';

void main() {
  group('CardDescription', () {
    test('can instantiate', () {
      expect(
        CardDescription(
          character: '',
          characterClass: '',
          power: '',
          location: '',
          description: '',
        ),
        isNotNull,
      );
    });

    test('can deserialize', () {
      expect(
        CardDescription.fromJson(
          const {
            'character': 'character',
            'characterClass': 'characterClass',
            'power': 'power',
            'location': 'location',
            'description': 'description',
          },
        ),
        equals(
          CardDescription(
            character: 'character',
            characterClass: 'characterClass',
            power: 'power',
            location: 'location',
            description: 'description',
          ),
        ),
      );
    });

    test('can serialize', () {
      expect(
        CardDescription(
          character: 'character',
          characterClass: 'characterClass',
          power: 'power',
          location: 'location',
          description: 'description',
        ).toJson(),
        equals(
          const {
            'character': 'character',
            'characterClass': 'characterClass',
            'powerShortened': 'powerShortened',
            'power': 'power',
            'location': 'location',
            'description': 'description',
          },
        ),
      );
    });
  });

  test('supports equality', () {
    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      equals(
        CardDescription(
          character: 'character',
          characterClass: 'characterClass',
          power: 'power',
          location: 'location',
          description: 'description',
        ),
      ),
    );

    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      isNot(
        equals(
          CardDescription(
            character: 'character1',
            characterClass: 'characterClass',
            power: 'power',
            location: 'location',
            description: 'description',
          ),
        ),
      ),
    );

    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      isNot(
        equals(
          CardDescription(
            character: 'character',
            characterClass: 'characterClass1',
            power: 'power',
            location: 'location',
            description: 'description',
          ),
        ),
      ),
    );

    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      isNot(
        equals(
          CardDescription(
            character: 'character',
            characterClass: 'characterClass',
            power: 'power1',
            location: 'location',
            description: 'description',
          ),
        ),
      ),
    );

    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      isNot(
        equals(
          CardDescription(
            character: 'character',
            characterClass: 'characterClass',
            power: 'power',
            location: 'location',
            description: 'description',
          ),
        ),
      ),
    );

    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      isNot(
        equals(
          CardDescription(
            character: 'character',
            characterClass: 'characterClass',
            power: 'power',
            location: 'location1',
            description: 'description',
          ),
        ),
      ),
    );

    expect(
      CardDescription(
        character: 'character',
        characterClass: 'characterClass',
        power: 'power',
        location: 'location',
        description: 'description',
      ),
      isNot(
        equals(
          CardDescription(
            character: 'character',
            characterClass: 'characterClass',
            power: 'power',
            location: 'location',
            description: 'description1',
          ),
        ),
      ),
    );
  });
}
