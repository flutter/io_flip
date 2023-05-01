import 'dart:async';
import 'dart:io';

import 'package:config_repository/config_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.get) {
    return _getConfigs(context);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

FutureOr<Response> _getConfigs(RequestContext context) async {
  final configRepository = context.read<ConfigRepository>();
  final privateMatchTimeLimit =
      await configRepository.getPrivateMatchTimeLimit();

  return Response.json(
    body: {
      'privateMatchTimeLimit': privateMatchTimeLimit,
    },
  );
}
