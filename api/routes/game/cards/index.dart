import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:prompt_repository/prompt_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    try {
      final cardsRepository = context.read<CardsRepository>();
      final promptRepository = context.read<PromptRepository>();
      final body = await context.request.json() as Map<String, dynamic>;
      final prompt = Prompt.fromJson(body);

      if (!await promptRepository.isValidPrompt(prompt)) {
        return Response(statusCode: HttpStatus.badRequest);
      }
      final cards = await Future.wait(
        List.generate(
          10,
          (_) => cardsRepository.generateCard(),
        ),
      );
      return Response.json(
        body: {'cards': cards.map((e) => e.toJson()).toList()},
      );
    } catch (e, s) {
      log('Error generating cards: $e', stackTrace: s);
      return Response(statusCode: HttpStatus.badRequest);
    }
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
