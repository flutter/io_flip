import 'dart:async';

import 'package:flutter/material.dart' hide Card, Element;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

enum ComparisonResult { player, opponent, none }

extension on int {
  ComparisonResult get result {
    if (this == 1) {
      return ComparisonResult.player;
    } else if (this == -1) {
      return ComparisonResult.opponent;
    } else {
      return ComparisonResult.none;
    }
  }
}

extension on TickerFuture {
  Future<void> get done => orCancel.then<void>((_) {}, onError: (_) {});
}

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

class ClashSceneState extends State<ClashScene> with TickerProviderStateMixin {
  Color bgColor = Colors.transparent;
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

  late final AnimationController damageController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  final Completer<void> damageCompleter = Completer<void>();

  Animation<int>? powerDecrementAnimation;

  late final ComparisonResult winningCard;
  late final ComparisonResult winningSuit;

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

  void onDamageRecieved() => damageController
    ..forward()
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        damageCompleter.complete();
      }
    });

  Future<void> onElementalComplete() async {
    if (winningCard != ComparisonResult.none) {
      setState(() {
        bgColor = Colors.black.withOpacity(0.5);
      });

      if (winningCard == ComparisonResult.player) {
        await playerController.run(playerAttackForwardAnimation).done;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await Future.wait([
          playerController.run(playerAttackBackAnimation).done,
          opponentController.run(opponentKnockOutAnimation).done,
        ]);
      } else if (winningCard == ComparisonResult.opponent) {
        await opponentController.run(opponentAttackForwardAnimation).done;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await Future.wait([
          opponentController.run(opponentAttackBackAnimation).done,
          playerController.run(playerKnockOutAnimation).done,
        ]);
      }
    }

    widget.onFinished();
  }

  void _getResults() {
    final gameScript = context.read<GameScriptMachine>();
    final playerCard = widget.playerCard;
    final opponentCard = widget.opponentCard;

    winningCard = gameScript.compare(playerCard, opponentCard).result;
    winningSuit =
        gameScript.compareSuits(playerCard.suit, opponentCard.suit).result;

    if (winningSuit != ComparisonResult.none) {
      int power;

      if (winningSuit == ComparisonResult.player) {
        power = widget.opponentCard.power;
      } else {
        power = widget.playerCard.power;
      }

      powerDecrementAnimation = IntTween(
        begin: power,
        end: power - 10,
      ).animate(
        CurvedAnimation(
          parent: damageController,
          curve: Curves.easeOutCirc,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getResults();
    motionController.forward();
    context.read<AudioController>().playSfx(Assets.sfx.flip);
  }

  @override
  void dispose() {
    motionController.dispose();
    opponentController.dispose();
    playerController.dispose();
    damageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cardSize = GameCardSize.md();
    final clashSceneSize = Size(cardSize.width * 1.7, cardSize.height * 2.15);
    final playerCard = AnimatedBuilder(
      key: const Key('player_card'),
      animation: motion,
      builder: (_, child) {
        return Positioned(
          bottom: 0,
          right: motion.value,
          child: child!,
        );
      },
      child: AnimatedCard(
        controller: playerController,
        front: const FlippedGameCard(
          size: cardSize,
        ),
        back: powerDecrementAnimation == null ||
                winningSuit == ComparisonResult.player
            ? GameCard(
                size: cardSize,
                image: widget.playerCard.image,
                name: widget.playerCard.name,
                description: widget.playerCard.description,
                power: widget.playerCard.power,
                suitName: widget.playerCard.suit.name,
                isRare: widget.playerCard.rarity,
              )
            : AnimatedBuilder(
                animation: powerDecrementAnimation!,
                builder: (_, __) {
                  return GameCard(
                    size: cardSize,
                    image: widget.playerCard.image,
                    name: widget.playerCard.name,
                    description: widget.playerCard.description,
                    power: powerDecrementAnimation!.value,
                    suitName: widget.playerCard.suit.name,
                    isRare: widget.playerCard.rarity,
                  );
                },
              ),
      ),
    );
    final opponentCard = AnimatedBuilder(
      key: const Key('opponent_card'),
      animation: motion,
      builder: (_, child) {
        return Positioned(
          top: 0,
          left: motion.value,
          child: child!,
        );
      },
      child: AnimatedCard(
        controller: opponentController,
        front: const FlippedGameCard(
          size: cardSize,
        ),
        back: powerDecrementAnimation == null ||
                winningSuit == ComparisonResult.opponent
            ? GameCard(
                size: cardSize,
                image: widget.opponentCard.image,
                name: widget.opponentCard.name,
                description: widget.opponentCard.description,
                power: widget.opponentCard.power,
                suitName: widget.opponentCard.suit.name,
                isRare: widget.opponentCard.rarity,
              )
            : AnimatedBuilder(
                animation: powerDecrementAnimation!,
                builder: (_, __) {
                  return GameCard(
                    size: cardSize,
                    image: widget.opponentCard.image,
                    name: widget.opponentCard.name,
                    description: widget.opponentCard.description,
                    power: powerDecrementAnimation!.value,
                    suitName: widget.opponentCard.suit.name,
                    isRare: widget.opponentCard.rarity,
                  );
                },
              ),
      ),
    );

    final winningElement = _elementsMap[winningSuit == ComparisonResult.player
        ? widget.playerCard.suit
        : widget.opponentCard.suit];

    if (_flipCards && winningSuit != ComparisonResult.none) {
      switch (winningElement!) {
        case Element.fire:
          context.read<AudioController>().playSfx(Assets.sfx.fire);
          break;
        case Element.air:
          context.read<AudioController>().playSfx(Assets.sfx.air);
          break;
        case Element.earth:
          context.read<AudioController>().playSfx(Assets.sfx.earth);
          break;
        case Element.metal:
          context.read<AudioController>().playSfx(Assets.sfx.metal);
          break;
        case Element.water:
          context.read<AudioController>().playSfx(Assets.sfx.water);
          break;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: bgColor,
      child: Center(
        child: SizedBox.fromSize(
          size: clashSceneSize,
          child: Stack(
            children: [
              if (winningCard == ComparisonResult.player) ...[
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
                  direction: winningSuit == ComparisonResult.player
                      ? DamageDirection.bottomToTop
                      : DamageDirection.topToBottom,
                  size: cardSize,
                  assetSize: platformAwareAsset<AssetSize>(
                    desktop: AssetSize.small,
                    mobile: AssetSize.small,
                  ),
                  initialState: winningSuit == ComparisonResult.none
                      ? DamageAnimationState.victory
                      : DamageAnimationState.charging,
                  onDamageReceived: onDamageRecieved,
                  pointDeductionCompleter: damageCompleter,
                  onComplete: onElementalComplete,
                )
            ],
          ),
        ),
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
