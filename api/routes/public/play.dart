import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gcloud_pubsub/gcloud_pubsub.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final matchRepository = context.read<MatchRepository>();
  try {
    // get elem from body
    // play card
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError, body: e.toString());
  }
  return Response(body: await context.request.body());
}
