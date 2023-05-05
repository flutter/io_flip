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

  /// Retrieves a prompt term for the given [term].
  Future<PromptTerm?> getByTerm(String term) async {
    final terms = await _dbClient.findBy(
      'prompt_terms',
      'term',
      term,
    );

    if (terms.isNotEmpty) {
      return PromptTerm.fromJson({
        'id': terms.first.id,
        ...terms.first.data,
      });
    }

    return null;
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
    final characterClass =
        await _dbClient.findBy('prompt_terms', 'term', prompt.characterClass);
    final powerValid = power.isNotEmpty && power.first.data['type'] == 'power';
    final characterClassValid = characterClass.isNotEmpty &&
        characterClass.first.data['type'] == 'characterClass';

    return powerValid && characterClassValid;
  }

  /// Takes a prompt combination and checks in the lookup tables
  /// if the given [imageUrl] exists.
  ///
  /// If it does, the [imageUrl] will be returned.
  ///
  /// If it doesn't exists, one of the variations present
  /// in the table will be returned instead.
  Future<String> ensurePromptImage({
    required String promptCombination,
    required String imageUrl,
  }) async {
    final results = await _dbClient.findBy(
      'image_lookup_table',
      'prompt',
      promptCombination,
    );

    // We assume that if a lookup table does not exists for the prompt
    // combination, that that combination has all the possible variations.
    if (results.isEmpty) {
      return imageUrl;
    } else {
      final images =
          (results.first.data['available_images'] as List).cast<String>();

      if (images.contains(imageUrl)) {
        return imageUrl;
      } else {
        final list = ([...images]..shuffle());
        if (list.isEmpty) {
          return imageUrl;
        }
        return list.first;
      }
    }
  }
}
