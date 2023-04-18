// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:data_loader/data_loader.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:test/test.dart';

class _MockPromptRepository extends Mock implements PromptRepository {}

class _MockFile extends Mock implements File {}

void main() {
  group('DataLoader', () {
    late DataLoader dataLoader;
    late PromptRepository promptRepository;
    late File csv;

    setUpAll(() {
      registerFallbackValue(
        PromptTerm(term: '', type: PromptTermType.character),
      );
    });

    setUp(() {
      promptRepository = _MockPromptRepository();
      when(() => promptRepository.createPromptTerm(any())).thenAnswer(
        (_) async {},
      );
      csv = _MockFile();
      dataLoader = DataLoader(
        promptRepository: promptRepository,
        csv: csv,
      );
    });

    test('can be instantiated', () {
      expect(
        DataLoader(
          promptRepository: _MockPromptRepository(),
          csv: _MockFile(),
        ),
        isNotNull,
      );
    });

    group('loadPromptTerms', () {
      test('load prompties correctly', () async {
        when(() => csv.readAsLines()).thenAnswer(
          (_) async => [
            'Character,Class,Power,Power,Location,',
            'Dash,Alien,Banjos,City,',
            ',Mage,Bass,Forest,',
          ],
        );

        await dataLoader.loadPromptTerms((_, __) {});

        verify(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: 'Dash',
              type: PromptTermType.character,
            ),
          ),
        ).called(1);
        verify(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: 'Alien',
              type: PromptTermType.characterClass,
            ),
          ),
        ).called(1);
        verify(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: 'Banjos',
              type: PromptTermType.power,
            ),
          ),
        ).called(1);
        verify(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: 'Bass',
              type: PromptTermType.power,
            ),
          ),
        ).called(1);
        verify(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: 'City',
              type: PromptTermType.location,
            ),
          ),
        ).called(1);
        verify(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: 'Forest',
              type: PromptTermType.location,
            ),
          ),
        ).called(1);
        verifyNever(
          () => promptRepository.createPromptTerm(
            PromptTerm(
              term: '',
              type: PromptTermType.character,
            ),
          ),
        );
      });

      test('progress is called correctly', () async {
        when(() => csv.readAsLines()).thenAnswer(
          (_) async => [
            'Character,Class,Power,Power,Location,',
            'Dash,Alien,Banjos,City,',
            ',Mage,Bass,Forest,',
          ],
        );

        final progress = <List<int>>[];
        await dataLoader.loadPromptTerms((current, total) {
          progress.add([current, total]);
        });

        expect(
          progress,
          equals(
            [
              [0, 7],
              [1, 7],
              [2, 7],
              [3, 7],
              [4, 7],
              [5, 7],
              [6, 7],
              [7, 7],
            ],
          ),
        );
      });
    });
  });
}
