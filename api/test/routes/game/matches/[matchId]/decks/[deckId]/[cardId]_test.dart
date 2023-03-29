import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../routes/game/matches/[matchId]/decks/[deckId]/cards/[cardId].dart'
    as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockMatchRepository extends Mock implements MatchRepository {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('POST /game/matches/[matchId]/decks/[deckId]/cards/[cardId]', () {
    late MatchRepository matchRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    const matchId = 'matchId';
    const deckId = 'deckId';
    const cardId = 'cardId';
    const userId = 'userId';
    const user = AuthenticatedUser(userId);

    setUp(() {
      matchRepository = _MockMatchRepository();
      when(
        () => matchRepository.playCard(
          matchId: matchId,
          deckId: deckId,
          cardId: cardId,
          userId: userId,
        ),
      ).thenAnswer(
        (_) async {},
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.post);

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<MatchRepository>()).thenReturn(matchRepository);
      when(() => context.read<Logger>()).thenReturn(logger);
      when(() => context.read<AuthenticatedUser>()).thenReturn(user);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, matchId, deckId, cardId);
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test("rethrows error when the card can't be played", () async {
      when(
        () => matchRepository.playCard(
          matchId: matchId,
          cardId: cardId,
          deckId: deckId,
          userId: userId,
        ),
      ).thenThrow(
        Exception('Ops'),
      );
      final response = route.onRequest(context, matchId, deckId, cardId);

      expect(response, throwsA(isA<Exception>()));
    });

    test('allows only post methods', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context, matchId, deckId, cardId);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
