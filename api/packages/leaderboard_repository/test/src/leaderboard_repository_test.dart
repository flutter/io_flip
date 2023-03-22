// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('LeaderboardRepository', () {
    late DbClient dbClient;
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      dbClient = _MockDbClient();
      leaderboardRepository = LeaderboardRepository(dbClient: dbClient);
    });

    test('can be instantiated', () {
      expect(
        LeaderboardRepository(dbClient: dbClient),
        isNotNull,
      );
    });

    group('getInitialsBlacklist', () {
      const blacklistDocumentId = 'MdOoZMhusnJTcwfYE0nL';

      const blacklist = ['AAA', 'BBB', 'CCC'];

      test('returns the blacklist', () async {
        when(() => dbClient.getById('initials_blacklist', blacklistDocumentId))
            .thenAnswer(
          (_) async => DbEntityRecord(
            id: blacklistDocumentId,
            data: const {
              'blacklist': ['AAA', 'BBB', 'CCC'],
            },
          ),
        );
        final response = await leaderboardRepository.getInitialsBlacklist();
        expect(response, equals(blacklist));
      });

      test('returns empty list if not found', () async {
        when(() => dbClient.getById('initials_blacklist', any())).thenAnswer(
          (_) async => null,
        );
        final response = await leaderboardRepository.getInitialsBlacklist();
        expect(response, equals([]));
      });
    });
  });
}
