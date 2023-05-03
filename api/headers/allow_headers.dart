import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

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
