// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('LeaderboardRepository', () {
    late DbClient dbClient;

    setUp(() {
      dbClient = _MockDbClient();
    });
    test('can be instantiated', () {
      expect(
        LeaderboardRepository(dbClient: dbClient),
        isNotNull,
      );
    });
  });
}
