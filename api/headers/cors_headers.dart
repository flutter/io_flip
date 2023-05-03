import 'package:dart_frog/dart_frog.dart';
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
