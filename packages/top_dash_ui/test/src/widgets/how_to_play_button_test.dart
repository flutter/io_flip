import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../helpers/go_router.dart';

void main() {
  group('HowToPlayButton', () {
    final goRouter = MockGoRouter();
    testWidgets('renders and responds to taps', (tester) async {
      await tester.pumpWidget(
        MockGoRouterProvider(
          goRouter: goRouter,
          child: const MaterialApp(
            home: Scaffold(
              body: HowToPlayButton(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(HowToPlayButton));

      verify(
        () => goRouter.go('/how_to_play'),
      ).called(1);
    });
  });
}
