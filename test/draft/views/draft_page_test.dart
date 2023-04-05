import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';

import '../../helpers/helpers.dart';

void main() {
  late final GoRouter router;

  setUp(() {
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: DraftPage.routeBuilder,
        ),
      ],
    );
  });

  group('DraftPage', () {
    testWidgets('navigates to draft page', (tester) async {
      await tester.pumpSubjectWithRouter(router);
      expect(find.byType(DraftPage), findsOneWidget);
    });
  });
}

extension DraftPageTest on WidgetTester {
  Future<void> pumpSubjectWithRouter(GoRouter goRouter) {
    return pumpAppWithRouter(goRouter);
  }
}
