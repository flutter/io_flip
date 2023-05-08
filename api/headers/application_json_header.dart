// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

extension ApplicationJsonX on Map<String, String> {
  bool isContentTypeJson() {
    return this[HttpHeaders.contentTypeHeader]
            ?.startsWith(ContentType.json.value) ??
        false;
  }
}

const methodsRequiringContentTypeJson = [
  HttpMethod.post,
  HttpMethod.put,
  HttpMethod.patch,
];

Middleware contentTypeHeader() {
  return (handler) {
    return (context) async {
      final method = context.request.method;
      final headers = context.request.headers;
      print(headers[HttpHeaders.contentTypeHeader]);

      if (methodsRequiringContentTypeJson.contains(method) &&
          !headers.isContentTypeJson()) {
        final path = context.request.uri.path;
        final message = '${HttpHeaders.contentTypeHeader} not allowed '
            'for ${method.value} $path';
        print(message);

        return Response(statusCode: HttpStatus.forbidden);
      }

      final response = await handler(context);
      return response;
    };
  };
}
