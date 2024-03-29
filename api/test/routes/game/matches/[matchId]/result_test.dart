import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/matches/[matchId]/result.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockMatchRepository extends Mock implements MatchRepository {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

class _FakeMatch extends Fake implements Match {}

class _FakeMatchState extends Fake implements MatchState {}

void main() {
  group('PATCH /game/matches/[matchId]/result', () {
    late MatchRepository matchRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    const deck = Deck(id: 'id', userId: 'userId', cards: []);
    const match = Match(id: 'id', hostDeck: deck, guestDeck: deck);
    const matchState = MatchState(
      id: '',
      matchId: '',
      guestPlayedCards: [],
      hostPlayedCards: [],
    );

    setUpAll(() {
      registerFallbackValue(_FakeMatch());
      registerFallbackValue(_FakeMatchState());
    });

    setUp(() {
      matchRepository = _MockMatchRepository();
      when(() => matchRepository.getMatch(match.id)).thenAnswer(
        (_) async => match,
      );
      when(() => matchRepository.getMatchState(match.id)).thenAnswer(
        (_) async => matchState,
      );
      when(
        () => matchRepository.calculateMatchResult(
          match: any(named: 'match'),
          matchState: any(named: 'matchState'),
        ),
      ).thenAnswer(
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

    test('responds with a 204', () async {
      final response = await route.onRequest(context, match.id);
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test('responds 400 when something goes wrong', () async {
      when(
        () => matchRepository.calculateMatchResult(
          match: any(named: 'match'),
          matchState: any(named: 'matchState'),
        ),
      ).thenThrow(CalculateResultFailure());
      final response = await route.onRequest(context, match.id);

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test("responds 404 when the match doesn't exists", () async {
      when(() => matchRepository.getMatch(match.id)).thenAnswer(
        (_) async => null,
      );
      final response = await route.onRequest(context, match.id);

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test("responds 404 when the match state doesn't exists", () async {
      when(() => matchRepository.getMatchState(match.id)).thenAnswer(
        (_) async => null,
      );
      final response = await route.onRequest(context, match.id);

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('allows only patch methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context, match.id);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
