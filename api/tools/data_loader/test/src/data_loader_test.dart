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

    test('load correctly', () async {
      when(() => csv.readAsLines()).thenAnswer(
        (_) async => [
          'Character,Class,Power 1,Power 2,Location,',
          'Dash,Alien,Banjos,Bass Guitars,City,',
          'Android,Alien,Banjos,Bass Guitars,City,',
        ],
      );

      await dataLoader.load((_, __) {});

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
            term: 'Android',
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
      ).called(2);
      verify(
        () => promptRepository.createPromptTerm(
          PromptTerm(
            term: 'Banjos',
            type: PromptTermType.power,
          ),
        ),
      ).called(2);
      verify(
        () => promptRepository.createPromptTerm(
          PromptTerm(
            term: 'Bass Guitars',
            type: PromptTermType.secondaryPower,
          ),
        ),
      ).called(2);
      verify(
        () => promptRepository.createPromptTerm(
          PromptTerm(
            term: 'City',
            type: PromptTermType.location,
          ),
        ),
      ).called(2);
    });

    test('progress is called correctly', () async {
      when(() => csv.readAsLines()).thenAnswer(
        (_) async => [
          'Character,Class,Power 1,Power 2,Location,',
          'Dash,Alien,Banjos,Bass Guitars,City,',
          'Android,Alien,Banjos,Bass Guitars,City,',
        ],
      );

      final progress = <List<int>>[];
      await dataLoader.load((current, total) {
        progress.add([current, total]);
      });

      expect(
        progress,
        equals(
          [
            [0, 10],
            [1, 10],
            [2, 10],
            [3, 10],
            [4, 10],
            [5, 10],
            [6, 10],
            [7, 10],
            [8, 10],
            [9, 10],
            [10, 10],
          ],
        ),
      );
    });
  });
}
