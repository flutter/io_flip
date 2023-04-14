import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gcloud_pubsub/gcloud_pubsub.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final pubsub = context.read<GcloudPubsub>();
  print('play card from topic');
  try {
    await pubsub.pushCardToQueue();
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError, body: e.toString());
  }
  return Response();
}
