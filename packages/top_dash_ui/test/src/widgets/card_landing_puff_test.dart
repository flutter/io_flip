import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class _MockImages extends Mock implements Images {}

void main() {
  group('CardLandingPuff', () {
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
            child: const CardLandingPuff(),
          ),
        ),
      );

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    test('description', () {
      expect(
        CardLandingPuff.duration.inMilliseconds,
        equals(CardLandingPuff.frames * CardLandingPuff.stepTime * 1000),
      );
    });
  });
}
