import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('TiltBuilder', () {
    const child = SizedBox(
      width: 200,
      height: 200,
      key: Key('child'),
    );
    Offset? lastOffset;

    Widget builder(BuildContext context, Offset tilt) {
      lastOffset = tilt;
      return child;
    }

    testWidgets('shows child', (tester) async {
      await tester.pumpWidget(TiltBuilder(builder: builder));

      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets('builds the child with offsets on mouse hover', (tester) async {
      await tester.pumpWidget(TiltBuilder(builder: builder));

      var offset = tester.getTopLeft(find.byType(TiltBuilder));
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveTo(offset);
      await tester.pumpAndSettle();
      expect(lastOffset, equals(const Offset(-1, -1)));

      offset = tester.getBottomRight(find.byType(TiltBuilder));
      await gesture.moveTo(offset - const Offset(1, 1));
      await tester.pumpAndSettle();

      expect(lastOffset?.dx, closeTo(1, 0.01));
      expect(lastOffset?.dy, closeTo(1, 0.01));

      await gesture.moveTo(offset + const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(lastOffset, equals(Offset.zero));
    });

    testWidgets('builds the child with offsets on touch drag', (tester) async {
      await tester.pumpWidget(TiltBuilder(builder: builder));

      var offset = tester.getTopLeft(find.byType(TiltBuilder));
      final gesture = await tester.startGesture(offset);
      await tester.pumpAndSettle();
      expect(lastOffset, equals(const Offset(-1, -1)));

      offset = tester.getBottomRight(find.byType(TiltBuilder));
      await gesture.moveTo(offset - const Offset(1, 1));
      await tester.pumpAndSettle();

      expect(lastOffset?.dx, closeTo(1, 0.01));
      expect(lastOffset?.dy, closeTo(1, 0.01));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(lastOffset, equals(Offset.zero));
    });
  });
}
