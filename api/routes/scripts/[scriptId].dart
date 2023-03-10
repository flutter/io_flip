import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:scripts_repository/scripts_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String scriptId) async {
  final scriptsRepository = context.read<ScriptsRepository>();
  if (context.request.method == HttpMethod.get) {
    final script = scriptId == 'current'
        ? (await scriptsRepository.getCurrentScript())
        : (await scriptsRepository.getScript(scriptId));

    return Response(body: script);
  } else if (context.request.method == HttpMethod.put) {
    final content = await context.request.body();
    if (scriptId == 'current') {
      context.read<GameScriptMachine>().currentScript = content;
      await scriptsRepository.updateCurrentScript(content);
    } else {
      await scriptsRepository.updateScript(scriptId, content);
    }

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
