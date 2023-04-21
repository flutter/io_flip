import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/game/matches/result.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockMatchRepository extends Mock implements MatchRepository {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /game/matches/[matchId]/result', () {
    late MatchRepository matchRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    setUp(() {
      matchRepository = _MockMatchRepository();
      when(() => matchRepository.calculateMatchResult(any())).thenAnswer(
        (_) async {},
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.patch);

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<MatchRepository>()).thenReturn(matchRepository);
      when(() => context.read<Logger>()).thenReturn(logger);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, 'matchId');
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test("responds 400 when the match doesn't exists", () async {
      when(() => matchRepository.calculateMatchResult(any()))
          .thenThrow(CalculateResultFailure());
      final response = await route.onRequest(context, 'matchId');

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('allows only patch methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context, 'matchId');
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
