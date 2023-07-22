import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockAudioController extends Mock implements AudioController {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClashScene', () {
    const playerCard = Card(
      id: 'player_card',
      name: 'host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 2,
      suit: Suit.air,
    );
    const firePlayerCard = Card(
      id: 'fire_player_card',
      name: 'fire_host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 2,
      suit: Suit.fire,
    );
    const earthPlayerCard = Card(
      id: 'earth_player_card',
      name: 'earth_host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 2,
      suit: Suit.earth,
    );
    const metalPlayerCard = Card(
      id: 'metal_player_card',
      name: 'metal_host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 2,
      suit: Suit.metal,
    );
    const waterPlayerCard = Card(
      id: 'water_player_card',
      name: 'water_host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 2,
      suit: Suit.water,
    );
    const waterPlayerCardWith11Power = Card(
      id: 'water_player_card',
      name: 'water_host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 11,
      suit: Suit.water,
    );
    const waterPlayerCardWith12Power = Card(
      id: 'water_player_card',
      name: 'water_host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 12,
      suit: Suit.water,
    );

    const opponentCard = Card(
      id: 'opponent_card',
      name: 'guest_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 1,
      suit: Suit.air,
    );
    const waterOpponentCard = Card(
      id: 'opponent_card',
      name: 'guest_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 1,
      suit: Suit.water,
    );

    late GameScriptMachine gameScriptMachine;

    setUp(() {
      gameScriptMachine = _MockGameScriptMachine();
    });

    testWidgets('displays both cards flipped initially and plays "flip" sfx',
        (tester) async {
      final audioController = _MockAudioController();

      when(
        () => gameScriptMachine.compare(
          playerCard,
          opponentCard,
        ),
      ).thenReturn(1);
      when(
        () => gameScriptMachine.compareSuits(
          playerCard.suit,
          opponentCard.suit,
        ),
      ).thenReturn(1);

      await tester.pumpSubject(
        playerCard,
        opponentCard,
        audioController: audioController,
        gameScriptMachine: gameScriptMachine,
      );

      verify(() => audioController.playSfx(Assets.sfx.flip)).called(1);

      expect(find.byType(FlippedGameCard), findsNWidgets(2));
    });

    testWidgets(
      'plays damage animation then flips both cards after countdown'
      ' ,invokes onFinished callback when animation is complete'
      ' and does not plays any sfx because the elements are the same',
      (tester) async {
        var onFinishedCalled = false;
        final audioController = _MockAudioController();

        when(
          () => gameScriptMachine.compare(
            playerCard,
            opponentCard,
          ),
        ).thenReturn(0);
        when(
          () => gameScriptMachine.compareSuits(
            playerCard.suit,
            opponentCard.suit,
          ),
        ).thenReturn(0);

        await tester.pumpSubject(
          playerCard,
          opponentCard,
          onFinished: () => onFinishedCalled = true,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await mockNetworkImages(() async {
          await tester.pump(smallFlipAnimation.duration * 2);
        });

        final elementalDamage = find.byType(ElementalDamageAnimation);

        verifyNever(() => audioController.playSfx(Assets.sfx.air));
        expect(elementalDamage, findsOneWidget);
        tester
            .widget<ElementalDamageAnimation>(elementalDamage)
            .onComplete
            ?.call();
        expect(onFinishedCalled, isTrue);
      },
    );

    testWidgets(
      'plays damage animation then flips both cards after countdown'
      ' ,invokes onFinished callback when animation is complete'
      ' and plays "air" sfx',
      (tester) => mockNetworkImages(() async {
        var onFinishedCalled = false;
        final audioController = _MockAudioController();

        when(
          () => gameScriptMachine.compare(
            playerCard,
            waterOpponentCard,
          ),
        ).thenReturn(1);
        when(
          () => gameScriptMachine.compareSuits(
            playerCard.suit,
            waterOpponentCard.suit,
          ),
        ).thenReturn(1);

        await tester.pumpSubject(
          playerCard,
          waterOpponentCard,
          onFinished: () => onFinishedCalled = true,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await tester.pump(smallFlipAnimation.duration * 2);

        final elementalDamage = find.byType(ElementalDamageAnimation);

        verify(() => audioController.playSfx(Assets.sfx.air)).called(1);
        expect(elementalDamage, findsOneWidget);
        tester
            .widget<ElementalDamageAnimation>(elementalDamage)
            .onComplete
            ?.call();

        await tester.pumpAndSettle();
        expect(onFinishedCalled, isTrue);
      }),
    );

    testWidgets(
      'plays damage animation then flips both cards after countdown'
      ' ,invokes onFinished callback when animation is complete'
      ' and plays "fire" sfx',
      (tester) => mockNetworkImages(() async {
        var onFinishedCalled = false;
        final audioController = _MockAudioController();

        when(
          () => gameScriptMachine.compare(
            firePlayerCard,
            opponentCard,
          ),
        ).thenReturn(1);
        when(
          () => gameScriptMachine.compareSuits(
            firePlayerCard.suit,
            opponentCard.suit,
          ),
        ).thenReturn(1);

        await tester.pumpSubject(
          firePlayerCard,
          opponentCard,
          onFinished: () => onFinishedCalled = true,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await tester.pump(smallFlipAnimation.duration * 2);

        final elementalDamage = find.byType(ElementalDamageAnimation);

        verify(() => audioController.playSfx(Assets.sfx.fire)).called(1);
        expect(elementalDamage, findsOneWidget);
        tester
            .widget<ElementalDamageAnimation>(elementalDamage)
            .onComplete
            ?.call();
        await tester.pumpAndSettle();
        expect(onFinishedCalled, isTrue);
      }),
    );

    testWidgets(
      'plays damage animation then flips both cards after countdown'
      ' ,invokes onFinished callback when animation is complete'
      ' and plays "earth" sfx',
      (tester) => mockNetworkImages(() async {
        var onFinishedCalled = false;
        final audioController = _MockAudioController();

        when(
          () => gameScriptMachine.compare(
            earthPlayerCard,
            opponentCard,
          ),
        ).thenReturn(1);
        when(
          () => gameScriptMachine.compareSuits(
            earthPlayerCard.suit,
            opponentCard.suit,
          ),
        ).thenReturn(1);

        await tester.pumpSubject(
          earthPlayerCard,
          opponentCard,
          onFinished: () => onFinishedCalled = true,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await tester.pump(smallFlipAnimation.duration * 2);

        final elementalDamage = find.byType(ElementalDamageAnimation);

        verify(() => audioController.playSfx(Assets.sfx.earth)).called(1);
        expect(elementalDamage, findsOneWidget);
        tester
            .widget<ElementalDamageAnimation>(elementalDamage)
            .onComplete
            ?.call();
        await tester.pumpAndSettle();
        expect(onFinishedCalled, isTrue);
      }),
    );

    testWidgets(
      'plays damage animation then flips both cards after countdown'
      ' ,invokes onFinished callback when animation is complete'
      ' and plays "metal" sfx',
      (tester) => mockNetworkImages(() async {
        var onFinishedCalled = false;
        final audioController = _MockAudioController();

        when(
          () => gameScriptMachine.compare(
            opponentCard,
            metalPlayerCard,
          ),
        ).thenReturn(-1);
        when(
          () => gameScriptMachine.compareSuits(
            opponentCard.suit,
            metalPlayerCard.suit,
          ),
        ).thenReturn(-1);

        await tester.pumpSubject(
          opponentCard,
          metalPlayerCard,
          onFinished: () => onFinishedCalled = true,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await tester.pump(smallFlipAnimation.duration * 2);

        final elementalDamage = find.byType(ElementalDamageAnimation);

        verify(() => audioController.playSfx(Assets.sfx.metal)).called(1);
        expect(elementalDamage, findsOneWidget);
        tester
            .widget<ElementalDamageAnimation>(elementalDamage)
            .onComplete
            ?.call();

        await tester.pumpAndSettle();

        expect(onFinishedCalled, isTrue);
      }),
    );

    testWidgets(
      'plays damage animation then flips both cards after countdown'
      ' ,invokes onFinished callback when animation is complete'
      ' and plays "water" sfx',
      (tester) => mockNetworkImages(() async {
        var onFinishedCalled = false;
        final audioController = _MockAudioController();

        when(
          () => gameScriptMachine.compare(
            waterPlayerCard,
            opponentCard,
          ),
        ).thenReturn(1);
        when(
          () => gameScriptMachine.compareSuits(
            waterPlayerCard.suit,
            opponentCard.suit,
          ),
        ).thenReturn(1);

        await tester.pumpSubject(
          waterPlayerCard,
          opponentCard,
          onFinished: () => onFinishedCalled = true,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await tester.pump(smallFlipAnimation.duration * 2);

        final elementalDamage = find.byType(ElementalDamageAnimation);

        verify(() => audioController.playSfx(Assets.sfx.water)).called(1);
        expect(elementalDamage, findsOneWidget);
        tester
            .widget<ElementalDamageAnimation>(elementalDamage)
            .onComplete
            ?.call();
        tester
            .state<ClashSceneState>(find.byType(ClashScene))
            .onDamageRecieved();

        await tester.pumpAndSettle();
        expect(onFinishedCalled, isTrue);
      }),
    );

    testWidgets(
      'puts players card over opponents when suit is stronger',
      (tester) async {
        when(
          () => gameScriptMachine.compare(
            playerCard,
            opponentCard,
          ),
        ).thenReturn(1);
        when(
          () => gameScriptMachine.compareSuits(
            playerCard.suit,
            opponentCard.suit,
          ),
        ).thenReturn(1);

        await tester.pumpSubject(
          playerCard,
          opponentCard,
          onFinished: () {},
          gameScriptMachine: gameScriptMachine,
        );

        final stack = find.byWidgetPredicate((stack) {
          if (stack is Stack) {
            return stack.children.first.key == const Key('opponent_card') &&
                stack.children[1].key == const Key('player_card');
          }
          return false;
        });

        expect(stack, findsOneWidget);
      },
    );

    testWidgets(
      'puts opponents card over players when suit is stronger',
      (tester) async {
        when(
          () => gameScriptMachine.compare(
            playerCard,
            opponentCard,
          ),
        ).thenReturn(-1);
        when(
          () => gameScriptMachine.compareSuits(
            playerCard.suit,
            opponentCard.suit,
          ),
        ).thenReturn(-1);

        await tester.pumpSubject(
          playerCard,
          opponentCard,
          onFinished: () {},
          gameScriptMachine: gameScriptMachine,
        );

        final stack = find.byWidgetPredicate((stack) {
          if (stack is Stack) {
            return stack.children.first.key == const Key('player_card') &&
                stack.children[1].key == const Key('opponent_card');
          }
          return false;
        });

        expect(stack, findsOneWidget);
      },
    );

    group('plays winning element sfx correctly', () {
      String sfxBySuit(Suit suit) {
        switch (suit) {
          case Suit.fire:
            return Assets.sfx.fire;
          case Suit.air:
            return Assets.sfx.air;
          case Suit.earth:
            return Assets.sfx.earth;
          case Suit.metal:
            return Assets.sfx.metal;
          case Suit.water:
            return Assets.sfx.water;
        }
      }

      Future<void> testCards(
        WidgetTester tester,
        Card player,
        Card opponent,
        int compareResult,
        int compareSuitsResult,
      ) async {
        final audioController = _MockAudioController();
        when(
          () => gameScriptMachine.compare(player, opponent),
        ).thenReturn(compareResult);
        when(
          () => gameScriptMachine.compareSuits(player.suit, opponent.suit),
        ).thenReturn(compareSuitsResult);
        await tester.pumpSubject(
          player,
          opponent,
          audioController: audioController,
          gameScriptMachine: gameScriptMachine,
        );
        tester
            .widget<FlipCountdown>(find.byType(FlipCountdown))
            .onComplete
            ?.call();
        await tester.pump(smallFlipAnimation.duration * 2);
        tester
            .widget<ElementalDamageAnimation>(
              find.byType(ElementalDamageAnimation),
            )
            .onComplete
            ?.call();
        await tester.pumpAndSettle();
        final playerSfxPlayed =
            (compareResult == 1 ? 1 : 0) + (compareSuitsResult == 1 ? 1 : 0);
        final opponentSfxPlayed =
            (compareResult == -1 ? 1 : 0) + (compareSuitsResult == -1 ? 1 : 0);
        if (playerSfxPlayed == 0) {
          verifyNever(() => audioController.playSfx(sfxBySuit(player.suit)));
        } else {
          verify(
            () => audioController.playSfx(sfxBySuit(player.suit)),
          ).called(playerSfxPlayed);
        }
        if (opponentSfxPlayed == 0) {
          verifyNever(() => audioController.playSfx(sfxBySuit(opponent.suit)));
        } else {
          verify(
            () => audioController.playSfx(sfxBySuit(opponent.suit)),
          ).called(opponentSfxPlayed);
        }
      }

      /// Covers all cases.
      testWidgets(
        'air V.S. air',
        (t) => testCards(t, playerCard, opponentCard, 0, 0),
      );
      testWidgets(
        'fire V.S. water',
        (t) => testCards(t, firePlayerCard, waterOpponentCard, 1, 1),
      );
      testWidgets(
        'water V.S. air',
        (t) => testCards(t, waterPlayerCard, opponentCard, -1, -1),
      );
      testWidgets(
        'water11 V.S. air',
        (t) => testCards(t, waterPlayerCardWith11Power, opponentCard, 0, -1),
      );
      testWidgets(
        'water12 V.S. air',
        (t) => testCards(t, waterPlayerCardWith12Power, opponentCard, 1, -1),
      );
    });
  });
}

extension GameViewTest on WidgetTester {
  Future<void> pumpSubject(
    Card playerCard,
    Card opponentCard, {
    VoidCallback? onFinished,
    AudioController? audioController,
    GameScriptMachine? gameScriptMachine,
  }) {
    return pumpApp(
      ClashScene(
        onFinished: onFinished ?? () {},
        opponentCard: opponentCard,
        playerCard: playerCard,
      ),
      audioController: audioController,
      gameScriptMachine: gameScriptMachine,
    );
  }
}
