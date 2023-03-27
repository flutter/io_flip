import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.bytes(
    body: utf8.encode('<html><body>Share</body></html>'),
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.html.toString(),
    },
  );
}
