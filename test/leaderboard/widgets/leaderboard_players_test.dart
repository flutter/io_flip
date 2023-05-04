import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LeaderboardPlayers', () {
    testWidgets('renders a list of players', (tester) async {
      const players = [
        LeaderboardPlayer(
          index: 0,
          initials: 'AAA',
          value: 100,
        ),
        LeaderboardPlayer(
          index: 1,
          initials: 'BBB',
          value: 50,
        ),
        LeaderboardPlayer(
          index: 2,
          initials: 'CCC',
          value: 25,
        ),
      ];

      await tester.pumpApp(const LeaderboardPlayers(players: players));

      expect(find.byType(LeaderboardPlayer), findsNWidgets(3));
    });
  });
}
