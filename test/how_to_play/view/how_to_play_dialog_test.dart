// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('HowToPlayDialog', () {
    testWidgets('renders a HowToPlayView', (tester) async {
      await tester.pumpApp(
        HowToPlayDialog(),
      );

      expect(find.byType(HowToPlayView), findsOneWidget);
    });
  });
}
