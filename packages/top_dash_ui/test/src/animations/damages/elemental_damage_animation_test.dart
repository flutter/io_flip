import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/src/animations/animations.dart';
import 'package:io_flip_ui/src/widgets/damages/damages.dart';
import 'package:io_flip_ui/src/widgets/damages/dual_animation.dart';
import 'package:io_flip_ui/src/widgets/game_card.dart';
import 'package:provider/provider.dart';

void main() {
  group('ElementalDamageAnimation', () {
    late Images images;

    setUp(() async {
      images = Images(prefix: '');

      await images.loadAll([
        Assets.images.elements.metal.chargeBack.keyName,
        Assets.images.elements.metal.chargeFront.keyName,
        Assets.images.elements.metal.damageReceive.keyName,
        Assets.images.elements.metal.damageSend.keyName,
        Assets.images.elements.metal.victoryChargeBack.keyName,
        Assets.images.elements.metal.victoryChargeFront.keyName,
        Assets.images.elements.air.chargeBack.keyName,
        Assets.images.elements.air.chargeFront.keyName,
        Assets.images.elements.air.damageReceive.keyName,
        Assets.images.elements.air.damageSend.keyName,
        Assets.images.elements.air.victoryChargeBack.keyName,
        Assets.images.elements.air.victoryChargeFront.keyName,
        Assets.images.elements.earth.chargeBack.keyName,
        Assets.images.elements.earth.chargeFront.keyName,
        Assets.images.elements.earth.damageReceive.keyName,
        Assets.images.elements.earth.damageSend.keyName,
        Assets.images.elements.earth.victoryChargeBack.keyName,
        Assets.images.elements.earth.victoryChargeFront.keyName,
        Assets.images.elements.fire.chargeBack.keyName,
        Assets.images.elements.fire.chargeFront.keyName,
        Assets.images.elements.fire.damageReceive.keyName,
        Assets.images.elements.fire.damageSend.keyName,
        Assets.images.elements.fire.victoryChargeBack.keyName,
        Assets.images.elements.fire.victoryChargeFront.keyName,
        Assets.images.elements.water.chargeBack.keyName,
        Assets.images.elements.water.chargeFront.keyName,
        Assets.images.elements.water.damageReceive.keyName,
        Assets.images.elements.water.damageSend.keyName,
        Assets.images.elements.water.victoryChargeBack.keyName,
        Assets.images.elements.water.victoryChargeFront.keyName,
      ]);
    });

    group('MetalDamage', () {
      testWidgets('renders entire animations flow', (tester) async {
        final stepNotifier = ElementalDamageStepNotifier();
        await tester.runAsync(() async {
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.metal,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  stepNotifier: stepNotifier,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(ChargeBack), findsOneWidget);
          expect(find.byType(ChargeFront), findsOneWidget);

          var chargedComplete = false;
          unawaited(
            stepNotifier.charged.then(
              (_) {
                chargedComplete = true;
              },
            ),
          );
          while (!chargedComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageSend), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageReceive), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(VictoryChargeBack), findsOneWidget);
          expect(find.byType(VictoryChargeFront), findsOneWidget);

          var victoryComplete = false;
          unawaited(
            stepNotifier.victory.then(
              (_) {
                victoryComplete = true;
              },
            ),
          );
          while (!victoryComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }
          expect(find.byType(SizedBox), findsOneWidget);
        });
      });
    });

    group('AirDamage', () {
      testWidgets('renders entire animations flow', (tester) async {
        final stepNotifier = ElementalDamageStepNotifier();
        await tester.runAsync(() async {
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.air,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  stepNotifier: stepNotifier,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(ChargeBack), findsOneWidget);
          expect(find.byType(ChargeFront), findsOneWidget);

          var chargedComplete = false;
          unawaited(
            stepNotifier.charged.then(
              (_) {
                chargedComplete = true;
              },
            ),
          );
          while (!chargedComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageSend), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageReceive), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(VictoryChargeBack), findsOneWidget);
          expect(find.byType(VictoryChargeFront), findsOneWidget);

          var victoryComplete = false;
          unawaited(
            stepNotifier.victory.then(
              (_) {
                victoryComplete = true;
              },
            ),
          );
          while (!victoryComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }
          expect(find.byType(SizedBox), findsOneWidget);
        });
      });
    });

    group('FireDamage', () {
      testWidgets('renders entire animations flow', (tester) async {
        final stepNotifier = ElementalDamageStepNotifier();
        await tester.runAsync(() async {
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.fire,
                  direction: DamageDirection.bottomToTop,
                  size: const GameCardSize.md(),
                  stepNotifier: stepNotifier,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(ChargeBack), findsOneWidget);
          expect(find.byType(ChargeFront), findsOneWidget);

          var chargedComplete = false;
          unawaited(
            stepNotifier.charged.then(
              (_) {
                chargedComplete = true;
              },
            ),
          );
          while (!chargedComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageSend), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageReceive), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(VictoryChargeBack), findsOneWidget);
          expect(find.byType(VictoryChargeFront), findsOneWidget);

          var victoryComplete = false;
          unawaited(
            stepNotifier.victory.then(
              (_) {
                victoryComplete = true;
              },
            ),
          );
          while (!victoryComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }
          expect(find.byType(SizedBox), findsOneWidget);
        });
      });
    });

    group('EarthDamage', () {
      testWidgets('renders entire animations flow', (tester) async {
        final stepNotifier = ElementalDamageStepNotifier();
        await tester.runAsync(() async {
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.earth,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  stepNotifier: stepNotifier,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(ChargeBack), findsOneWidget);
          expect(find.byType(ChargeFront), findsOneWidget);

          var chargedComplete = false;
          unawaited(
            stepNotifier.charged.then(
              (_) {
                chargedComplete = true;
              },
            ),
          );
          while (!chargedComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageSend), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageReceive), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(VictoryChargeBack), findsOneWidget);
          expect(find.byType(VictoryChargeFront), findsOneWidget);

          var victoryComplete = false;
          unawaited(
            stepNotifier.victory.then(
              (_) {
                victoryComplete = true;
              },
            ),
          );
          while (!victoryComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }
          expect(find.byType(SizedBox), findsOneWidget);
        });
      });
    });

    group('WaterDamage', () {
      testWidgets('renders entire animations flow', (tester) async {
        final stepNotifier = ElementalDamageStepNotifier();
        await tester.runAsync(() async {
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.water,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  stepNotifier: stepNotifier,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(ChargeBack), findsOneWidget);
          expect(find.byType(ChargeFront), findsOneWidget);

          var chargedComplete = false;
          unawaited(
            stepNotifier.charged.then(
              (_) {
                chargedComplete = true;
              },
            ),
          );
          while (!chargedComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageSend), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DamageReceive), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }

          expect(find.byType(DualAnimation), findsOneWidget);
          expect(find.byType(SpriteAnimationWidget), findsNWidgets(2));
          expect(find.byType(VictoryChargeBack), findsOneWidget);
          expect(find.byType(VictoryChargeFront), findsOneWidget);

          var victoryComplete = false;
          unawaited(
            stepNotifier.victory.then(
              (_) {
                victoryComplete = true;
              },
            ),
          );
          while (!victoryComplete) {
            await tester.pump(const Duration(milliseconds: 17));
          }
          expect(find.byType(SizedBox), findsOneWidget);
        });
      });
    });
  });
}
