import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/info/info.dart';
import 'package:top_dash/info/widgets/info_button.dart';

import '../../helpers/helpers.dart';

void main() {
  group('InfoView', () {
    testWidgets('can navigate to the info view', (tester) async {
      await tester.pumpApp(const Scaffold(body: InfoButton()));

      await tester.tap(find.byType(InfoButton));
      await tester.pumpAndSettle();

      expect(find.byType(InfoView), findsOneWidget);
    });
  });
}
