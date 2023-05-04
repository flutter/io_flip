import 'package:game_domain/game_domain.dart';

/// A mapping of the CSV columns to the [PromptTermType].
const promptColumnMap = {
  0: PromptTermType.character,
  1: PromptTermType.characterClass,
  2: PromptTermType.power,
  4: PromptTermType.location,
};

/// Given the [lines] of a CSV file, returns a map of [PromptTermType];
Map<PromptTermType, List<String>> mapCsvToPrompts(List<String> lines) {
  final map = {
    for (final term in PromptTermType.values) term: <String>[],
  };

  for (final line in lines.skip(1)) {
    final parts = line.split(',');

    for (var j = 0; j < promptColumnMap.length; j++) {
      final idx = promptColumnMap.keys.elementAt(j);
      final type = promptColumnMap.values.elementAt(j);

      final value = parts[idx].trim();
      if (value.isNotEmpty) {
        map[type]!.add(value);
      }
    }
  }
  return map;
}
