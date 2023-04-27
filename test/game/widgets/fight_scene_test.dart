import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FightScene', () {
    const playerCard = Card(
      id: 'player_card',
      name: 'host_card',
      description: '',
      image: 'image.png',
      rarity: true,
      power: 2,
      suit: Suit.air,
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

    testWidgets('displays both cards flipped initially', (tester) async {
      await tester.pumpSubject(playerCard, opponentCard);

      expect(find.byType(FlippedGameCard), findsNWidgets(2));
    });

    testWidgets(
      'flips both cards after countdown and invokes onFinished '
      'callback when animation is complete',
      (tester) async {
        var onFinishedCalled = false;

        await tester.pumpSubject(
          playerCard,
          opponentCard,
          onFinished: () => onFinishedCalled = true,
        );

        final flipCountdown = find.byType(FlipCountdown);
        expect(flipCountdown, findsOneWidget);
        tester.widget<FlipCountdown>(flipCountdown).onComplete?.call();

        await mockNetworkImages(() async {
          await tester.pump(smallFlipAnimation.duration * 2);
          await tester.pump(const Duration(seconds: 2));
        });

        expect(find.byType(GameCard), findsNWidgets(2));
        expect(onFinishedCalled, isTrue);
      },
    );
  });
}

extension GameViewTest on WidgetTester {
  Future<void> pumpSubject(
    Card playerCard,
    Card opponentCard, {
    VoidCallback? onFinished,
  }) {
    return pumpApp(
      FightScene(
        onFinished: onFinished ?? () {},
        opponentCard: opponentCard,
        playerCard: playerCard,
      ),
    );
  }
}
