import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/leaderboard/initials/index.dart' as route;

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('POST /game/leaderboard/initials', () {
    late LeaderboardRepository leaderboardRepository;
    late Request request;
    late RequestContext context;

    const initials = 'AAA';
    const scoreCardId = 'mock-scoreCardId';

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();
      when(
        () => leaderboardRepository.addInitialsToScoreCard(
          scoreCardId: any(named: 'scoreCardId'),
          initials: any(named: 'initials'),
        ),
      ).thenAnswer((_) async => {});
      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.json).thenAnswer(
        (_) async => {
          'initials': initials,
          'scoreCardId': scoreCardId,
        },
      );

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
    });

    test('responds with a 204', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test('responds with a 400 when request is invalid', () async {
      when(request.json).thenAnswer((_) async => {'test': 'test'});
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('allows only post methods', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
