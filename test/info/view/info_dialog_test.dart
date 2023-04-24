// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/info/info.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('InfoDialog', () {
    testWidgets('renders a InfoView', (tester) async {
      await tester.pumpApp(InfoDialog());

      expect(find.byType(InfoView), findsOneWidget);
    });
  });
}
