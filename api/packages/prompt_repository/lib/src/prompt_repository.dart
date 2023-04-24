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

  /// Retrieves the prompt terms.
  Future<List<PromptTerm>> getPromptTerms() async {
    final terms = await _dbClient.orderBy(
      'prompt_terms',
      'type',
      limit: 100,
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
    final promptTerms = await getPromptTerms();

    if (_isValidPrompt(
          prompt.power!,
          promptTerms.byType(PromptTermType.power),
        ) &&
        _isValidPrompt(
          prompt.characterClass!,
          promptTerms.byType(PromptTermType.characterClass),
        ) &&
        _isValidPrompt(
          prompt.secondaryPower!,
          promptTerms.byType(PromptTermType.power),
        )) {
      return true;
    }
    return false;
  }

  bool _isValidPrompt(
    String prompt,
    List<PromptTerm> promptTerms,
  ) {
    return promptTerms.any((element) => element.term == prompt);
  }
}

extension _FilterByType on List<PromptTerm> {
  List<PromptTerm> byType(PromptTermType type) {
    return [...where((element) => element.type == type)];
  }
}
