import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template prompt_repository}
/// Access to Prompt datasource.
/// {@endtemplate}
class PromptRepository {
  /// {@macro prompt_repository}
  const PromptRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  /// Retrieves the prompt terms for the given [type].
  Future<List<PromptTerm>> getPromptTermsByType(PromptTermType type) async {
    final terms = await _dbClient.findBy(
      'prompt_terms',
      'type',
      type.name,
    );

    return terms
        .map(
          (entity) => PromptTerm.fromJson({
            'id': entity.id,
            ...entity.data,
          }),
        )
        .toList();
  }

  /// Creates a new prompt term.
  Future<void> createPromptTerm(PromptTerm promptTerm) async {
    await _dbClient.add(
      'prompt_terms',
      promptTerm.toJson()..remove('id'),
    );
  }

  /// Check if the attributes in a [Prompt] are valid
  Future<bool> isValidPrompt(Prompt prompt) async {
    final power = await _dbClient.findBy('prompt_terms', 'term', prompt.power);
    final secondaryPower =
        await _dbClient.findBy('prompt_terms', 'term', prompt.secondaryPower);
    final characterClass =
        await _dbClient.findBy('prompt_terms', 'term', prompt.characterClass);
    final powerValid = power.isNotEmpty && power.first.data['type'] == 'power';
    final secondaryPowerValid = secondaryPower.isNotEmpty &&
        secondaryPower.first.data['type'] == 'power';
    final characterClassValid = characterClass.isNotEmpty &&
        characterClass.first.data['type'] == 'characterClass';

    return powerValid && secondaryPowerValid && characterClassValid;
  }
}
