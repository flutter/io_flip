import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/src/animations/animations.dart';
import 'package:top_dash_ui/src/widgets/damages/charge_back.dart';
import 'package:top_dash_ui/src/widgets/damages/charge_front.dart';
import 'package:top_dash_ui/src/widgets/damages/dual_animation.dart';
import 'package:top_dash_ui/src/widgets/game_card.dart';

void main() {
  group('ElementalDamageAnimation', () {
    late Images images;

    setUp(() {
      images = Images(prefix: '');
    });

    group('MetalDamage', () {
      testWidgets('renders SpriteAnimationWidget', (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.metal,
                  direction: DamageDirection.topToBottom,
                  size: GameCardSize.md(),
                ),
              ),
            ),
          );

          for (var i = 0; i < 24; i++) {
            await tester.pump();
//            await tester.pumpAndSettle();
          }

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(ChargeBack), findsOneWidget);
          expect(find.byType(ChargeFront), findsOneWidget);
        });
      });
    });

    group('AirDamage', () {
      testWidgets('renders SpriteAnimationWidget', (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.air,
                direction: DamageDirection.topToBottom,
                size: GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('FireDamage', () {
      testWidgets('renders SpriteAnimationWidget', (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.fire,
                direction: DamageDirection.topToBottom,
                size: GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('EarthDamage', () {
      testWidgets('renders SpriteAnimationWidget', (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.earth,
                direction: DamageDirection.topToBottom,
                size: GameCardSize.md(),
              ),
            ),
          ),
        );

        expect(find.byType(DualAnimation), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
      });
    });

    group('WaterDamage', () {
      testWidgets('renders SpriteAnimationWidget', (tester) async {
        await tester.pumpWidget(
          Provider.value(
            value: images,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: ElementalDamageAnimation(
                Element.water,
                direction: DamageDirection.topToBottom,
                size: GameCardSize.md(),
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
