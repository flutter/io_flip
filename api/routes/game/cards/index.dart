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
      final body =
          jsonDecode(await context.request.body()) as Map<String, dynamic>;
      final prompt = Prompt.fromJson(body);
      final promptTerms = await promptRepository.getPromptTerms();

      if (_isValidPrompt(
            prompt.power!,
            promptTerms.byType(PromptTermType.power),
          ) &&
          _isValidPrompt(
            prompt.characterClass!,
            promptTerms.byType(PromptTermType.characterClass),
          )) {}
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

bool _isValidPrompt(
  String prompt,
  List<PromptTerm> promptTerms,
) {
  return promptTerms.any((element) => element.term == prompt);
}

extension ByType on List<PromptTerm> {
  List<PromptTerm> byType(PromptTermType type) {
    return [...where((element) => element.type == type)];
  }
}
