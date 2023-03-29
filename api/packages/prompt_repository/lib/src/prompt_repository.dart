import 'package:db_client/db_client.dart';

/// {@template prompt_repository}
/// Access to Prompt datasource.
/// {@endtemplate}
class PromptRepository {
  /// {@macro prompt_repository}
  const PromptRepository({
    required DbClient dbClient,
    required String whitelistDocumentId,
  })  : _dbClient = dbClient,
        _whitelistDocumentId = whitelistDocumentId;

  final DbClient _dbClient;

  final String _whitelistDocumentId;

  /// Retrieves the whitelist for prompt.
  Future<List<String>> getPromptWhitelist() async {
    final whitelistData = await _dbClient.getById(
      'prompt_whitelist',
      _whitelistDocumentId,
    );

    if (whitelistData == null) {
      return [];
    }

    return (whitelistData.data['whitelist'] as List).cast<String>();
  }
}
