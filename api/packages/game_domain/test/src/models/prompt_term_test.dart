// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('PromptTerm', () {
    test('can be instantiated', () {
      expect(
        PromptTerm(
          id: '',
          term: '',
          type: PromptTermType.character,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      final promptTerm = PromptTerm(
        id: '',
        term: '',
        type: PromptTermType.character,
      );

      expect(
        promptTerm,
        equals(
          PromptTerm(
            id: '',
            term: '',
            type: PromptTermType.character,
          ),
        ),
      );

      expect(
        promptTerm,
        isNot(
          equals(
            PromptTerm(
              id: '',
              term: '',
              type: PromptTermType.location,
            ),
          ),
        ),
      );

      expect(
        promptTerm,
        isNot(
          equals(
            PromptTerm(
              id: 'id',
              term: '',
              type: PromptTermType.location,
            ),
          ),
        ),
      );

      expect(
        promptTerm,
        isNot(
          equals(
            PromptTerm(
              id: '',
              term: 'term',
              type: PromptTermType.location,
            ),
          ),
        ),
      );
    });

    test('can serializes to json', () {
      final promptTerm = PromptTerm(
        id: 'id',
        term: 'term',
        type: PromptTermType.location,
      );

      expect(
        promptTerm.toJson(),
        equals(
          {
            'id': 'id',
            'term': 'term',
            'type': 'location',
          },
        ),
      );
    });

    test('can deserialize from json', () {
      final promptTerm = PromptTerm.fromJson(
        const {
          'id': 'id',
          'term': 'term',
          'type': 'location',
        },
      );

      expect(
        promptTerm,
        equals(
          PromptTerm(
            id: 'id',
            term: 'term',
            type: PromptTermType.location,
          ),
        ),
      );
    });
  });
}
