import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:prompt_repository/prompt_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final type = context.request.uri.queryParameters['type'];

    final promptType = PromptTermType.values.firstWhereOrNull(
      (element) => element.name == type,
    );

    if (promptType == null) {
      return Response(statusCode: HttpStatus.badRequest, body: 'Invalid type');
    }

    final promptRepository = context.read<PromptRepository>();
    final list = await promptRepository.getPromptTermsByType(
      promptType,
    );
    return Response.json(body: {'list': list.map((e) => e.term).toList()});
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
