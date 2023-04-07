import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  late LeaderboardResource leaderboardResource;

  setUp(() {
    leaderboardResource = _MockLeaderboardResource();
    when(() => leaderboardResource.getInitialsBlacklist())
        .thenAnswer((_) async => []);
  });

  group('LeaderboardEntryView', () {
    testWidgets('renders correct title', (tester) async {
      await tester.pumpSubject(leaderboardResource);

      final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

      expect(find.text(l10n.enterYourInitials), findsOneWidget);
    });

    testWidgets('renders initials form', (tester) async {
      await tester.pumpSubject(leaderboardResource);

      expect(find.byType(InitialsForm), findsOneWidget);
    });
  });
}

extension LeaderboardEntryViewTest on WidgetTester {
  Future<void> pumpSubject(
    LeaderboardResource leaderboardResource,
  ) async {
    return pumpApp(
      const LeaderboardEntryView(
        scoreCardId: 'scoreCardId',
      ),
      leaderboardResource: leaderboardResource,
    );
  }
}
