import 'dart:async';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    // TODO(hugo): Get prompts from request body to use in generation
    final cardsRepository = context.read<CardsRepository>();
    final cards = await Future.wait(
      List.generate(
        10,
        (_) => cardsRepository.generateCard(),
      ),
    );
    return Response.json(
      body: {'cards': cards.map((e) => e.toJson()).toList()},
    );
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
