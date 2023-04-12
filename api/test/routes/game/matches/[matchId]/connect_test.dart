// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/matches/[matchId]/connect.dart' as route;

class _MockMatchRepository extends Mock implements MatchRepository {}

class _MockCardsRepository extends Mock implements CardsRepository {}

class _MockAuthenticatedUser extends Mock implements AuthenticatedUser {}

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

void main() {
  late CardsRepository cardsRepository;
  late MatchRepository matchRepository;
  late AuthenticatedUser user;
  late Request request;
  late RequestContext context;

  const matchId = 'matchId';
  const userId = 'userId';
  const card = Card(
    id: '',
    name: '',
    description: '',
    rarity: true,
    image: '',
    power: 1,
    suit: Suit.air,
  );

  setUp(() {
    cardsRepository = _MockCardsRepository();
    when(
      () => cardsRepository.createDeck(
        cardIds: any(named: 'cardIds'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => 'deckId');
    when(cardsRepository.generateCard).thenAnswer((_) async => card);

    matchRepository = _MockMatchRepository();
    when(
      () => matchRepository.setCpuConnectivity(
        matchId: matchId,
        hostId: userId,
      ),
    ).thenAnswer(
      (_) async {},
    );
    when(
      () => matchRepository.getPlayerConnectivity(userId: userId),
    ).thenAnswer((_) => Future.value(true));

    user = _MockAuthenticatedUser();
    when(() => user.id).thenReturn(userId);

    request = _MockRequest();
    when(() => request.method).thenReturn(HttpMethod.post);
    when(request.json).thenAnswer(
      (_) async => {
        'cards': ['a', 'b', 'c'],
        'userId': userId,
      },
    );
    context = _MockRequestContext();
    when(() => context.request).thenReturn(request);
    when(() => request.uri)
        .thenReturn(Uri.parse('https://game/matches/connect?matchId=$matchId'));
    when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
    when(() => context.read<AuthenticatedUser>()).thenReturn(user);
    when(() => context.read<MatchRepository>()).thenReturn(matchRepository);
  });

  group('POST /game/matches/connect', () {
    test('responds with a 200', () async {
      final response = await route.onRequest(context, matchId);
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test('responds with a 401 if user not connected to match', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) => Future.value(false));
      final response = await route.onRequest(context, matchId);
      expect(response.statusCode, equals(HttpStatus.forbidden));
    });

    test("responds with a 405 if method isn't POST", () async {
      when(() => request.method).thenReturn(HttpMethod.put);
      final response = await route.onRequest(context, matchId);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with a 500 if something happens', () async {
      when(
        () => matchRepository.setCpuConnectivity(
          matchId: matchId,
          hostId: userId,
        ),
      ).thenThrow(Exception(''));
      final response = await route.onRequest(context, matchId);
      expect(response.statusCode, equals(HttpStatus.internalServerError));
    });
  });
}
