import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/src/animations/animations.dart';
import 'package:top_dash_ui/src/widgets/damages/dual_animation.dart';
import 'package:top_dash_ui/src/widgets/game_card.dart';

class _MockImages extends Mock implements Images {}

void main() {
  group('ElementalDamageAnimation', () {
    late Images images;

    setUp(() {
      images = _MockImages();
    });

    group('MetalDamage', () {
      testWidgets('renders SpriteAnimationWidget for metal element',
          (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.metal,
                direction: DamageDirection.topToBottom,
                onComplete: () {},
                size: const GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('AirDamage', () {
      testWidgets('renders SpriteAnimationWidget for metal element',
          (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.air,
                direction: DamageDirection.topToBottom,
                onComplete: () {},
                size: const GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('FireDamage', () {
      testWidgets('renders SpriteAnimationWidget for metal element',
          (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.fire,
                direction: DamageDirection.topToBottom,
                onComplete: () {},
                size: const GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('EarthDamage', () {
      testWidgets('renders SpriteAnimationWidget for metal element',
          (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.earth,
                direction: DamageDirection.topToBottom,
                onComplete: () {},
                size: const GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('WaterDamage', () {
      testWidgets('renders SpriteAnimationWidget for metal element',
          (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.water,
                direction: DamageDirection.topToBottom,
                onComplete: () {},
                size: const GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });
  });
}
