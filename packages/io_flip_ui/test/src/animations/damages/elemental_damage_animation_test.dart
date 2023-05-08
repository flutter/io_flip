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
    final findEmpty = find.byKey(const Key('elementalDamage_empty'));
    late Images images;

    setUp(() async {
      images = Images(prefix: '');

      await images.loadAll([
        ...Assets.images.elements.desktop.air.values.map((e) => e.keyName),
        ...Assets.images.elements.desktop.earth.values.map((e) => e.keyName),
        ...Assets.images.elements.desktop.fire.values.map((e) => e.keyName),
        ...Assets.images.elements.desktop.metal.values.map((e) => e.keyName),
        ...Assets.images.elements.desktop.water.values.map((e) => e.keyName),
        ...Assets.images.elements.mobile.air.values.map((e) => e.keyName),
        ...Assets.images.elements.mobile.earth.values.map((e) => e.keyName),
        ...Assets.images.elements.mobile.fire.values.map((e) => e.keyName),
        ...Assets.images.elements.mobile.metal.values.map((e) => e.keyName),
        ...Assets.images.elements.mobile.water.values.map((e) => e.keyName),
      ]);
    });

    group('With large assets', () {
      group('MetalDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.runAsync(() async {
            await tester.pumpWidget(
              Provider.value(
                value: images,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ElementalDamageAnimation(
                    Element.metal,
                    direction: DamageDirection.topToBottom,
                    initialState: DamageAnimationState.charging,
                    size: const GameCardSize.md(),
                    stepNotifier: stepNotifier,
                    pointDeductionCompleter: completer,
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

            completer.complete();
            await tester.pump();
            expect(findEmpty, findsOneWidget);
            await tester.pump();

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
            expect(findEmpty, findsOneWidget);
          });
        });
      });

      group('AirDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
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
                    initialState: DamageAnimationState.charging,
                    stepNotifier: stepNotifier,
                    pointDeductionCompleter: completer,
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

            completer.complete();
            await tester.pump();
            expect(findEmpty, findsOneWidget);
            await tester.pump();

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
            expect(findEmpty, findsOneWidget);
          });
        });
      });

      group('FireDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.runAsync(() async {
            await tester.pumpWidget(
              Provider.value(
                value: images,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ElementalDamageAnimation(
                    Element.fire,
                    direction: DamageDirection.bottomToTop,
                    initialState: DamageAnimationState.charging,
                    size: const GameCardSize.md(),
                    stepNotifier: stepNotifier,
                    pointDeductionCompleter: completer,
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

            completer.complete();
            await tester.pump();
            expect(findEmpty, findsOneWidget);
            await tester.pump();

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
            expect(findEmpty, findsOneWidget);
          });
        });
      });

      group('EarthDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.runAsync(() async {
            await tester.pumpWidget(
              Provider.value(
                value: images,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ElementalDamageAnimation(
                    Element.earth,
                    direction: DamageDirection.topToBottom,
                    initialState: DamageAnimationState.charging,
                    size: const GameCardSize.md(),
                    stepNotifier: stepNotifier,
                    pointDeductionCompleter: completer,
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

            completer.complete();
            await tester.pump();
            expect(findEmpty, findsOneWidget);
            await tester.pump();

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
            expect(findEmpty, findsOneWidget);
          });
        });
      });

      group('WaterDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.runAsync(() async {
            await tester.pumpWidget(
              Provider.value(
                value: images,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ElementalDamageAnimation(
                    Element.water,
                    direction: DamageDirection.topToBottom,
                    initialState: DamageAnimationState.charging,
                    size: const GameCardSize.md(),
                    stepNotifier: stepNotifier,
                    pointDeductionCompleter: completer,
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

            completer.complete();
            await tester.pump();
            expect(findEmpty, findsOneWidget);
            await tester.pump();

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
            expect(findEmpty, findsOneWidget);
          });
        });
      });
    });

    group('With small assets', () {
      group('MetalDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.metal,
                  direction: DamageDirection.bottomToTop,
                  size: const GameCardSize.md(),
                  initialState: DamageAnimationState.charging,
                  assetSize: AssetSize.small,
                  stepNotifier: stepNotifier,
                  pointDeductionCompleter: completer,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          expect(find.byType(DamageSend), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 15));
          }

          expect(find.byType(DamageReceive), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          completer.complete();
          await tester.pump();
          expect(findEmpty, findsOneWidget);
          await tester.pump();

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }
          expect(findEmpty, findsOneWidget);
        });
      });

      group('AirDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.air,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  initialState: DamageAnimationState.charging,
                  assetSize: AssetSize.small,
                  stepNotifier: stepNotifier,
                  pointDeductionCompleter: completer,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          expect(find.byType(DamageSend), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 15));
          }

          expect(find.byType(DamageReceive), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          completer.complete();
          await tester.pump();
          expect(findEmpty, findsOneWidget);
          await tester.pump();

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }
          expect(findEmpty, findsOneWidget);
        });
      });

      group('FireDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.fire,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  initialState: DamageAnimationState.charging,
                  assetSize: AssetSize.small,
                  stepNotifier: stepNotifier,
                  pointDeductionCompleter: completer,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          expect(find.byType(DamageSend), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 15));
          }

          expect(find.byType(DamageReceive), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          completer.complete();
          await tester.pump();
          expect(findEmpty, findsOneWidget);
          await tester.pump();

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }
          expect(findEmpty, findsOneWidget);
        });
      });

      group('EarthDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.earth,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  initialState: DamageAnimationState.charging,
                  assetSize: AssetSize.small,
                  stepNotifier: stepNotifier,
                  pointDeductionCompleter: completer,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          expect(find.byType(DamageSend), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 15));
          }

          expect(find.byType(DamageReceive), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          completer.complete();
          await tester.pump();
          expect(findEmpty, findsOneWidget);
          await tester.pump();

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }
          expect(findEmpty, findsOneWidget);
        });
      });

      group('WaterDamage', () {
        testWidgets('renders entire animations flow', (tester) async {
          final stepNotifier = ElementalDamageStepNotifier();
          final completer = Completer<void>();
          await tester.pumpWidget(
            Provider.value(
              value: images,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ElementalDamageAnimation(
                  Element.water,
                  direction: DamageDirection.topToBottom,
                  size: const GameCardSize.md(),
                  initialState: DamageAnimationState.charging,
                  assetSize: AssetSize.small,
                  stepNotifier: stepNotifier,
                  pointDeductionCompleter: completer,
                ),
              ),
            ),
          );

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          expect(find.byType(DamageSend), findsOneWidget);

          var sendComplete = false;
          unawaited(
            stepNotifier.sent.then(
              (_) {
                sendComplete = true;
              },
            ),
          );
          while (!sendComplete) {
            await tester.pump(const Duration(milliseconds: 15));
          }

          expect(find.byType(DamageReceive), findsOneWidget);

          var receiveComplete = false;
          unawaited(
            stepNotifier.received.then(
              (_) {
                receiveComplete = true;
              },
            ),
          );
          while (!receiveComplete) {
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }

          completer.complete();
          await tester.pump();
          expect(findEmpty, findsOneWidget);
          await tester.pump();

          expect(find.byType(DualAnimation), findsOneWidget);
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
            await tester.pumpAndSettle(const Duration(milliseconds: 150));
          }
          expect(findEmpty, findsOneWidget);
        });
      });
    });
  });
}
