import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LeaderboardPage', () {
    testWidgets('renders LeaderboardView', (tester) async {
      await tester.pumpApp(const LeaderboardPage());
      expect(find.byType(LeaderboardView), findsOneWidget);
    });
  });
}
