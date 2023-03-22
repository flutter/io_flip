import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

class _MockInitialsFormBloc
    extends MockBloc<InitialsFormEvent, InitialsFormState>
    implements InitialsFormBloc {}

void main() {
  late InitialsFormBloc initialsFormBloc;

  setUp(() {
    initialsFormBloc = _MockInitialsFormBloc();
  });

  group('LeaderboardEntryView', () {
    testWidgets('renders correct title and subtitle', (tester) async {
      await tester.pumpSubject();

      final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

      expect(find.text(l10n.youMadeItToTheLeaderboard), findsOneWidget);
      expect(find.text(l10n.enterYourInitials), findsOneWidget);
    });

    testWidgets('renders initials form', (tester) async {
      await tester.pumpSubject();

      expect(find.byType(InitialsForm), findsOneWidget);
    });
  });
}

extension LeaderboardEntryViewTest on WidgetTester {
  Future<void> pumpSubject() async {
    return pumpApp(
      const LeaderboardEntryView(),
    );
  }
}
