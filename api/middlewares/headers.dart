import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

import '../main.dart';

Middleware corsHeaders() {
  return fromShelfMiddleware(
    shelf.corsHeaders(
      headers: {
        shelf.ACCESS_CONTROL_ALLOW_ORIGIN: gameUrl.url,
      },
    ),
  );
}

Middleware allowHeaders() {
  return (handler) {
    return (context) async {
      final response = await handler(context);
      final headers = Map<String, String>.from(response.headers);
      final accessControlAllowHeaders = headers[ACCESS_CONTROL_ALLOW_HEADERS];
      if (accessControlAllowHeaders != null) {
        headers[ACCESS_CONTROL_ALLOW_HEADERS] =
            '$accessControlAllowHeaders, $X_FIREBASE_APPCHECK';

        return response.copyWith(headers: headers);
      }

      return response;
    };
  };
}
