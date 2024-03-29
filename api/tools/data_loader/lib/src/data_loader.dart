import 'dart:io';

import 'package:data_loader/src/prompt_mapper.dart';
import 'package:game_domain/game_domain.dart';
import 'package:prompt_repository/prompt_repository.dart';

/// {@template data_loader}
/// Dart tool that feed data into the Database
/// {@endtemplate}
class DataLoader {
  /// {@macro data_loader}
  const DataLoader({
    required PromptRepository promptRepository,
    required File csv,
  })  : _promptRepository = promptRepository,
        _csv = csv;

  final PromptRepository _promptRepository;
  final File _csv;

  /// Loads the data from the CSV file into the database
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> loadPromptTerms(void Function(int, int) onProgress) async {
    final prompts = <PromptTerm>[];

    final lines = await _csv.readAsLines();

    for (final line in lines.skip(1)) {
      final parts = line.split(',');

      for (var j = 0; j < promptColumnMap.length; j++) {
        final idx = promptColumnMap.keys.elementAt(j);
        final type = promptColumnMap.values.elementAt(j);
        if (parts[idx].isNotEmpty) {
          prompts.add(
            PromptTerm(
              term: parts[idx],
              shortenedTerm:
                  type == PromptTermType.power ? parts[idx + 1] : null,
              type: type,
            ),
          );
        }
      }
    }

    var progress = 0;
    onProgress(progress, prompts.length);

    for (final prompt in prompts) {
      await _promptRepository.createPromptTerm(prompt);
      progress++;

      /// So we don't hit rate limits.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      onProgress(progress, prompts.length);
    }
  }
}
