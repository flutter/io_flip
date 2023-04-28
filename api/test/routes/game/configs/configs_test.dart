import 'dart:io';

import 'package:config_repository/config_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/game/configs/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockConfigRepository extends Mock implements ConfigRepository {}

class _MockRequest extends Mock implements Request {}

void main() {
  group('GET /game/configs', () {
    late ConfigRepository configRepository;
    late Request request;
    late RequestContext context;

    setUp(() {
      configRepository = _MockConfigRepository();
      when(configRepository.getPrivateMatchTimeLimit).thenAnswer(
        (_) async => 120,
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.request).thenReturn(request);

      when(() => context.read<ConfigRepository>()).thenReturn(configRepository);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with a json of the configs', () async {
      final response = await route.onRequest(context);
      final json = await response.json();
      expect(
        json,
        equals(
          {
            'privateMatchTimeLimit': 120,
          },
        ),
      );
    });

    test('allows only get methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
