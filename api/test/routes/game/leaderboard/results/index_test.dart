import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/leaderboard/results/index.dart' as route;

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    late LeaderboardRepository leaderboardRepository;
    late Request request;
    late RequestContext context;

    const leaderboardPlayers = [
      LeaderboardPlayer(
        id: 'id',
        longestStreak: 1,
        initials: 'AAA',
      ),
      LeaderboardPlayer(
        id: 'id2',
        longestStreak: 2,
        initials: 'BBB',
      ),
      LeaderboardPlayer(
        id: 'id3',
        longestStreak: 3,
        initials: 'CCC',
      ),
    ];

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();
      when(() => leaderboardRepository.getLeaderboard()).thenAnswer(
        (_) async => leaderboardPlayers,
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
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

    test('responds with the list of leaderboard players', () async {
      final response = await route.onRequest(context);

      final json = await response.json();

      expect(
        json,
        equals({
          'leaderboardPlayers': [
            {
              'id': 'id',
              'longestStreak': 1,
              'initials': 'AAA',
            },
            {
              'id': 'id2',
              'longestStreak': 2,
              'initials': 'BBB',
            },
            {
              'id': 'id3',
              'longestStreak': 3,
              'initials': 'CCC',
            },
          ],
        }),
      );
    });
  });
}
