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
  Future<List<PromptTerm>> getPromptTerms(PromptTermType type) async {
    final terms = await _dbClient.findBy(
      'prompt_terms',
      'type',
      type,
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
}
