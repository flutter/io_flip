import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/matches/[matchId]/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockMatchRepository extends Mock implements MatchRepository {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /game/matches/[matchId]', () {
    late MatchRepository matchRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    const hostDeck = Deck(
      id: 'hostDeckId',
      userId: 'hostUserId',
      cards: [
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          power: 10,
          rarity: false,
          suit: Suit.air,
        ),
      ],
    );

    const guestDeck = Deck(
      id: 'guestDeckId',
      userId: 'guestUserId',
      cards: [
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          power: 10,
          rarity: false,
          suit: Suit.air,
        ),
      ],
    );

    const match = Match(
      id: 'matchId',
      guestDeck: guestDeck,
      hostDeck: hostDeck,
    );

    setUp(() {
      matchRepository = _MockMatchRepository();
      when(() => matchRepository.getMatch(any())).thenAnswer(
        (_) async => match,
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);
      when(request.json).thenAnswer(
        (_) async => match.toJson(),
      );

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<MatchRepository>()).thenReturn(matchRepository);
      when(() => context.read<Logger>()).thenReturn(logger);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, match.id);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with the match', () async {
      final response = await route.onRequest(context, match.id);

      final json = await response.json() as Map<String, dynamic>;
      expect(
        json,
        equals(match.toJson()),
      );
    });

    test("responds 404 when the match doesn't exists", () async {
      when(() => matchRepository.getMatch(any())).thenAnswer((_) async => null);
      final response = await route.onRequest(context, match.id);

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('allows only get methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context, match.id);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
