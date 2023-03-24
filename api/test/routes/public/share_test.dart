import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/public/share.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /public/share', () {
    late Request request;
    late RequestContext context;
    late Logger logger;

    setUp(() {
      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<Logger>()).thenReturn(logger);
    });

    test('responds with a 200', () async {
      final response = route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });
  });
}
