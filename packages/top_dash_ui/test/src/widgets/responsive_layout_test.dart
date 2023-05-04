import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

extension _TopDashWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    addTearDown(() {
      view
        ..resetPhysicalSize()
        ..resetDevicePixelRatio();
    });
  }
}

void main() {
  group('ResponsiveLayout', () {
    testWidgets('displays a large layout', (tester) async {
      tester.setDisplaySize(const Size(TopDashBreakpoints.medium, 800));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(largeKey), findsOneWidget);
      expect(find.byKey(smallKey), findsNothing);
    });

    testWidgets('displays a small layout', (tester) async {
      tester.setDisplaySize(const Size(TopDashBreakpoints.medium, 1200));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(smallKey), findsOneWidget);
    });

    testWidgets('displays child when available (large)', (tester) async {
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const childKey = Key('__child__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(key: smallKey, child: child),
          large: (_, child) => SizedBox(key: largeKey, child: child),
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(smallKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('displays child when available (small)', (tester) async {
      tester.setDisplaySize(const Size(TopDashBreakpoints.medium, 800));

      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const childKey = Key('__child__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(key: smallKey, child: child),
          large: (_, child) => SizedBox(key: largeKey, child: child),
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(largeKey), findsOneWidget);
      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(childKey), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
