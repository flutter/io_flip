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
        ...Assets.images.elements.large.air.values.map((e) => e.keyName),
        ...Assets.images.elements.large.earth.values.map((e) => e.keyName),
        ...Assets.images.elements.large.fire.values.map((e) => e.keyName),
        ...Assets.images.elements.large.metal.values.map((e) => e.keyName),
        ...Assets.images.elements.large.water.values.map((e) => e.keyName),
        ...Assets.images.elements.small.air.values.map((e) => e.keyName),
        ...Assets.images.elements.small.earth.values.map((e) => e.keyName),
        ...Assets.images.elements.small.fire.values.map((e) => e.keyName),
        ...Assets.images.elements.small.metal.values.map((e) => e.keyName),
        ...Assets.images.elements.small.water.values.map((e) => e.keyName),
      ]);
    });

    group('With large assets', () {
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

    group('With small assets', () {
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
                    assetSize: AssetSize.small,
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
                    assetSize: AssetSize.small,
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
                    assetSize: AssetSize.small,
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
                    assetSize: AssetSize.small,
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
                    assetSize: AssetSize.small,
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
  });
}
