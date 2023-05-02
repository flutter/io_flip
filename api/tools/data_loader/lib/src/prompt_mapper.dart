import 'package:game_domain/game_domain.dart';

/// Given the [lines] of a CSV file, returns a map of [PromptTermType];
Map<PromptTermType, List<String>> mapCsvToPrompts(List<String> lines) {
  final map = {
    for (final term in PromptTermType.values) term: <String>[],
  };

  for (final line in lines.skip(1)) {
    final parts = line.split(',');

    for (var j = 0; j < 4; j++) {
      final value = parts[j].trim();
      if (value.isNotEmpty) {
        final type = PromptTermType.values[j];
        map[type]!.add(value);
      }
    }
  }
  return map;
}
