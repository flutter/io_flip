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

    testWidgets('renders SpriteAnimationWidget', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Provider.value(
            value: images,
            child: const FlipCountdown(),
          ),
        ),
      );

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });
}
