import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scripts_repository/scripts_repository.dart';
import 'package:test/test.dart';

import '../../../../main.dart';
import '../../../../routes/game/scripts/[scriptId].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockScriptsRepository extends Mock implements ScriptsRepository {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /game/scripts/[scriptId]', () {
    late ScriptsRepository scriptsRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    setUp(() {
      scriptsRepository = _MockScriptsRepository();
      when(scriptsRepository.getCurrentScript)
          .thenAnswer((_) async => 'script');

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<ScriptsRepository>())
          .thenReturn(scriptsRepository);
      when(() => context.read<Logger>()).thenReturn(logger);

      when(() => context.read<ScriptsState>()).thenReturn(ScriptsState.enabled);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, 'current');
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with a 404 if using the wrong id', () async {
      final response = await route.onRequest(context, '');
      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('responds with a not allowed when the wrong method', () async {
      when(() => request.method).thenReturn(HttpMethod.head);
      final response = await route.onRequest(context, '');
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with the script', () async {
      final response = await route.onRequest(context, 'current');

      final body = await response.body();
      expect(
        body,
        equals('script'),
      );
    });
  });

  group('PUT /scripts/[scriptId]', () {
    late ScriptsRepository scriptsRepository;
    late GameScriptMachine gameScriptMachine;
    late Request request;
    late RequestContext context;
    late Logger logger;

    setUp(() {
      scriptsRepository = _MockScriptsRepository();
      gameScriptMachine = _MockGameScriptMachine();
      when(() => scriptsRepository.updateCurrentScript(any()))
          .thenAnswer((_) async {});

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.put);
      when(request.body).thenAnswer((_) async => 'the script');

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<ScriptsRepository>())
          .thenReturn(scriptsRepository);
      when(() => context.read<Logger>()).thenReturn(logger);
      when(() => context.read<GameScriptMachine>())
          .thenReturn(gameScriptMachine);

      when(() => context.read<ScriptsState>()).thenReturn(ScriptsState.enabled);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, 'current');
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test('responds with a 404 if using the wrong id', () async {
      final response = await route.onRequest(context, '');
      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('responds with a not allowed when the wrong method', () async {
      when(() => request.method).thenReturn(HttpMethod.head);
      final response = await route.onRequest(context, '');
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('update the script on the db', () async {
      await route.onRequest(context, 'current');
      verify(() => scriptsRepository.updateCurrentScript('the script'))
          .called(1);
    });

    test('update the script in the current machine', () async {
      await route.onRequest(context, 'current');
      verify(() => gameScriptMachine.currentScript = 'the script').called(1);
    });

    test('responds with a 405 if scripts are not enabled', () async {
      when(() => context.read<ScriptsState>())
          .thenReturn(ScriptsState.disabled);
      final response = await route.onRequest(context, 'current');
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
