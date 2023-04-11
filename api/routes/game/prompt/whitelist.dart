import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:prompt_repository/prompt_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final type = context.request.uri.queryParameters['type'];

    final promptTypeList = PromptTermType.values.where(
      (element) => element.name == type,
    );

    if (promptTypeList.isEmpty) {
      return Response(statusCode: HttpStatus.badRequest, body: 'Invalid type');
    }

    final leaderboardRepository = context.read<PromptRepository>();
    final list = await leaderboardRepository.getPromptTerms(
      promptTypeList.first,
    );
    return Response.json(body: {'list': list.map((e) => e.term).toList()});
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
