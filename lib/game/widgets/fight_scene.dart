import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class FightScene extends StatefulWidget {
  const FightScene({
    required this.onFinished,
    required this.opponentCard,
    required this.playerCard,
    super.key,
  });

  final VoidCallback onFinished;
  final Card opponentCard;
  final Card playerCard;

  @override
  State<StatefulWidget> createState() => FightSceneState();
}

class FightSceneState extends State<FightScene> {
  final AnimatedCardController opponentController = AnimatedCardController();
  final AnimatedCardController playerController = AnimatedCardController();

  var _flipCards = false;

  void onFlipCards() {
    setState(() => _flipCards = true);

    opponentController.run(smallFlipAnimation);
    playerController.run(smallFlipAnimation);

    Future.delayed(const Duration(seconds: 2), () => widget.onFinished());
  }

  @override
  void dispose() {
    opponentController.dispose();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: TopDashColors.seedBlack,
      child: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: AnimatedCard(
                controller: opponentController,
                front: const FlippedGameCard(),
                back: GameCard(
                  image: widget.opponentCard.image,
                  name: widget.opponentCard.name,
                  description: widget.opponentCard.description,
                  power: widget.opponentCard.power,
                  suitName: widget.opponentCard.suit.name,
                  isRare: widget.opponentCard.rarity,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedCard(
                controller: playerController,
                front: const FlippedGameCard(),
                back: GameCard(
                  image: widget.playerCard.image,
                  name: widget.playerCard.name,
                  description: widget.playerCard.description,
                  power: widget.playerCard.power,
                  suitName: widget.playerCard.suit.name,
                  isRare: widget.playerCard.rarity,
                ),
              ),
            ),
            Positioned.fill(
              child: Visibility(
                visible: !_flipCards,
                child: FlipCountdown(
                  onComplete: onFlipCards,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
