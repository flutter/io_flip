// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('IoFlipLogo', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(IoFlipLogo());

      expect(
        find.byType(IoFlipLogo),
        findsOneWidget,
      );
    });

    testWidgets('white renders correctly', (tester) async {
      await tester.pumpWidget(IoFlipLogo.white());

      expect(
        find.byType(IoFlipLogo),
        findsOneWidget,
      );
    });

    testWidgets('renders size correctly', (tester) async {
      await tester.pumpWidget(IoFlipLogo(width: 200, height: 100));
      expect(
        tester.widget(find.byType(IoFlipLogo)),
        isA<IoFlipLogo>()
            .having((i) => i.width, 'width', 200)
            .having((i) => i.height, 'height', 100),
      );
    });
  });
}
