import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template scripts_resource}
/// Resource to access the scripts api.
/// {@endtemplate}
class ScriptsResource {
  /// {@macro scripts_resource}
  ScriptsResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get /scripts/current
  Future<String> getCurrentScript() async {
    final response = await _apiClient.get('/scripts/current');

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /scripts/current returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    return response.body;
  }

  /// Put /scripts/:id
  Future<void> updateScript(String id, String content) async {
    final response = await _apiClient.put(
      '/scripts/$id',
      body: content,
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiClientError(
        'PUT /scripts/$id returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }
  }
}
