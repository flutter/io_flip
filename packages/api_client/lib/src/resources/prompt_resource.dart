import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template prompt_resource}
/// An api resource to get the prompt whitelist.
/// {@endtemplate}
class PromptResource {
  /// {@macro prompt_resource}
  PromptResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get /game/prompt/whitelist
  ///
  /// Returns a [List<String>].
  Future<List<String>> getPromptWhitelist() async {
    final response = await _apiClient.get('/game/prompt/whitelist');

    if (response.statusCode == HttpStatus.notFound) {
      return [];
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /prompt/whitelist returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['list'] as List).cast<String>();
    } catch (e) {
      throw ApiClientError(
        'GET /prompt/whitelist returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }
}
