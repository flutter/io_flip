import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockImages extends Mock implements Images {}

void main() {
  group('FlipCountdown', () {
    late Images images;

    setUp(() {
      images = _MockImages();
    });

    testWidgets('renders SpriteAnimationWidget on desktop', (tester) async {
      await tester.pumpWidget(
        Theme(
          data: IoFlipTheme.themeData.copyWith(platform: TargetPlatform.macOS),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Provider.value(
              value: images,
              child: const FlipCountdown(),
            ),
          ),
        ),
      );

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('renders other animation on mobile', (tester) async {
      var complete = false;
      await tester.pumpWidget(
        Theme(
          data: IoFlipTheme.themeData.copyWith(platform: TargetPlatform.iOS),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Provider.value(
              value: images,
              child: FlipCountdown(
                onComplete: () {
                  complete = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SpriteAnimationWidget), findsNothing);
      expect(find.byKey(const Key('flipCountdown_mobile')), findsOneWidget);

      await tester.pumpAndSettle();

      expect(complete, isTrue);
    });
  });
}
