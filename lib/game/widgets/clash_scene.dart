import 'package:flutter/material.dart' hide Card, Element;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class ClashScene extends StatefulWidget {
  const ClashScene({
    required this.onFinished,
    required this.opponentCard,
    required this.playerCard,
    super.key,
  });

  final VoidCallback onFinished;
  final Card opponentCard;
  final Card playerCard;

  @override
  State<StatefulWidget> createState() => ClashSceneState();
}

class ClashSceneState extends State<ClashScene>
    with SingleTickerProviderStateMixin {
  final AnimatedCardController opponentController = AnimatedCardController();
  final AnimatedCardController playerController = AnimatedCardController();
  late final AnimationController motionController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  late final motion = TweenSequence([
    TweenSequenceItem(tween: Tween<double>(begin: 60, end: 15), weight: 4),
    TweenSequenceItem(tween: Tween<double>(begin: 15, end: 0), weight: 5),
  ]).animate(
    CurvedAnimation(parent: motionController, curve: Curves.easeOutCirc),
  );

  var _flipCards = false;

  void onFlipCards() {
    motionController.stop();
    Future.delayed(
      const Duration(milliseconds: 100),
      () => opponentController.run(smallFlipAnimation),
    );

    playerController.run(smallFlipAnimation);
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() => _flipCards = true),
    );
  }

  @override
  void initState() {
    super.initState();
    motionController.forward();
    context.read<AudioController>().playSfx(Assets.sfx.flip);
  }

  @override
  void dispose() {
    motionController.dispose();
    opponentController.dispose();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerCard = AnimatedBuilder(
      key: const Key('player_card'),
      animation: motion,
      builder: (_, __) {
        return Positioned(
          bottom: 0,
          right: motion.value,
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
        );
      },
    );
    final opponentCard = AnimatedBuilder(
      key: const Key('opponent_card'),
      animation: motion,
      builder: (_, __) {
        return Positioned(
          top: 0,
          left: motion.value,
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
        );
      },
    );
    final playerWins = widget.playerCard.power > widget.opponentCard.power;
    final winningElement = _elementsMap[
        playerWins ? widget.playerCard.suit : widget.opponentCard.suit];
    return Center(
      child: Stack(
        children: [
          if (playerWins) ...[
            opponentCard,
            playerCard
          ] else ...[
            playerCard,
            opponentCard
          ],
          Positioned.fill(
            child: Visibility(
              visible: !_flipCards,
              child: FlipCountdown(
                onComplete: onFlipCards,
              ),
            ),
          ),
          if (_flipCards)
            ElementalDamageAnimation(
              winningElement!,
              direction: playerWins
                  ? DamageDirection.bottomToTop
                  : DamageDirection.topToBottom,
              size: const GameCardSize.lg(),
              assetSize: platformAwareAsset<AssetSize>(
                desktop: AssetSize.large,
                mobile: AssetSize.small,
              ),
              onComplete: widget.onFinished,
            )
        ],
      ),
    );
  }

  static const _elementsMap = {
    Suit.air: Element.air,
    Suit.earth: Element.earth,
    Suit.fire: Element.fire,
    Suit.metal: Element.metal,
    Suit.water: Element.water,
  };
}
