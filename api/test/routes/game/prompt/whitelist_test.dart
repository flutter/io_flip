import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:test/test.dart';

import '../../../../routes/game/prompt/whitelist.dart'
    as route;

class _MockPromptRepository extends Mock
    implements PromptRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    late PromptRepository promptRepository;
    late Request request;
    late RequestContext context;

    const blacklist = ['AAA', 'BBB', 'CCC'];

    setUp(() {
      promptRepository = _MockPromptRepository();
      when(() => promptRepository.getPromptWhitelist())
          .thenAnswer((_) async => blacklist);

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<PromptRepository>())
          .thenReturn(promptRepository);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('only allows get methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with the whitelist', () async {
      final response = await route.onRequest(context);

      final json = await response.json();
      expect(
        json,
        equals({
          'list': ['AAA', 'BBB', 'CCC'],
        }),
      );
    });
  });
}
