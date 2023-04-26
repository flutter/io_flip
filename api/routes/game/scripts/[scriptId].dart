import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:scripts_repository/scripts_repository.dart';

import '../../../main.dart';

FutureOr<Response> onRequest(RequestContext context, String scriptId) async {
  final scriptsRepository = context.read<ScriptsRepository>();
  final scritpsState = context.read<ScriptsState>();

  if (context.request.method == HttpMethod.get) {
    if (scriptId != 'current') {
      return Response(statusCode: HttpStatus.notFound);
    }
    final script = await scriptsRepository.getCurrentScript();

    return Response(body: script);
  } else if (context.request.method == HttpMethod.put &&
      scritpsState == ScriptsState.enabled) {
    if (scriptId != 'current') {
      return Response(statusCode: HttpStatus.notFound);
    }

    final content = await context.request.body();
    context.read<GameScriptMachine>().currentScript = content;
    await scriptsRepository.updateCurrentScript(content);

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
