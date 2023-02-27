// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/match_making/match_making.dart';

import '../../helpers/helpers.dart';

class _MockMatchMaker extends Mock implements MatchMaker {}

void main() {
  group('MatchMakingPage', () {
    test('routeBuilder returns a MatchMakingPage', () {
      expect(
        MatchMakingPage.routeBuilder(null, null),
        isA<MatchMakingPage>(),
      );
    });

    testWidgets('renders a MatchMakingView', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(MatchMakingView), findsOneWidget);
    });
  });
}

extension MatchMakingPageTest on WidgetTester {
  Future<void> pumpSubject() {
    return pumpApp(
      Provider<MatchMaker>(
        create: (_) => _MockMatchMaker(),
        child: MatchMakingPage(),
      ),
    );
  }
}
