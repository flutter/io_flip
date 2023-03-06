import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('TopDashTheme', () {
    group('themeData', () {
      test('uses material 3', () {
        expect(TopDashTheme.themeData.useMaterial3, isTrue);
      });

      test('background color is TopDashColors.backgroundMain', () {
        expect(
          TopDashTheme.themeData.colorScheme.background,
          TopDashColors.backgroundMain,
        );
      });
    });
  });
}
