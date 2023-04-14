import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  log('play card from topic');
  if (context.request.method == HttpMethod.post) {
    //final json = await context.request.json() as Map<String, dynamic>;
    return Response(
        statusCode: HttpStatus.ok, body: await context.request.body());
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
