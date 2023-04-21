import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template prompt_resource}
/// An api resource to get the prompt terms.
/// {@endtemplate}
class PromptResource {
  /// {@macro prompt_resource}
  PromptResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get /game/prompt/terms
  ///
  /// Returns a [List<String>].
  Future<List<String>> getPromptTerms(PromptTermType termType) async {
    final response = await _apiClient.get(
      '/game/prompt/terms',
      queryParameters: {'type': termType.name},
    );

    if (response.statusCode == HttpStatus.notFound) {
      return [];
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /prompt/terms returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['list'] as List).cast<String>();
    } catch (e) {
      throw ApiClientError(
        'GET /prompt/terms returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }
}
