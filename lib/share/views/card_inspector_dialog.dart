import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

typedef ShowShareDialog = Future<void> Function(Card card);

class CardInspectorDialog extends StatefulWidget {
  const CardInspectorDialog({
    required this.deck,
    required this.playerCardIds,
    required this.startingIndex,
    super.key,
  });

  final List<String> playerCardIds;
  final List<Card> deck;
  final int startingIndex;

  @override
  State<CardInspectorDialog> createState() => _CardInspectorDialogState();
}

class _CardInspectorDialogState extends State<CardInspectorDialog> {
  late final start = widget.deck.length * 300 + widget.startingIndex;
  late final controller = PageController(initialPage: start);

  @override
  Widget build(BuildContext context) {
    const transitionDuration = Duration(milliseconds: 200);
    const phoneHeight = 600;
    const smallestPhoneHeight = 500;
    final height = MediaQuery.sizeOf(context).height;
    final cardSize = height > phoneHeight
        ? const GameCardSize.xxl()
        : const GameCardSize.xl();
    return Dialog(
      insetPadding: const EdgeInsets.all(IoFlipSpacing.sm),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardViewer(
            controller: controller,
            deck: widget.deck,
            share: (card) => IoFlipDialog.show(
              context,
              child: ShareCardDialog(card: card),
            ),
            size: cardSize,
            playerCardIds: widget.playerCardIds,
          ),
          if (height > smallestPhoneHeight)
            Padding(
              padding: const EdgeInsets.all(IoFlipSpacing.lg),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BackButton(
                    controller: controller,
                    transitionDuration: transitionDuration,
                  ),
                  const SizedBox(width: IoFlipSpacing.lg),
                  _ForwardButton(
                    controller: controller,
                    transitionDuration: transitionDuration,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _ForwardButton extends StatelessWidget {
  const _ForwardButton({
    required this.controller,
    required this.transitionDuration,
  });

  final PageController controller;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    return RoundedButton.icon(
      Icons.arrow_forward,
      onPressed: () => controller.nextPage(
        duration: transitionDuration,
        curve: Curves.linear,
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.controller,
    required this.transitionDuration,
  });

  final PageController controller;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    return RoundedButton.icon(
      Icons.arrow_back,
      onPressed: () => controller.previousPage(
        duration: transitionDuration,
        curve: Curves.linear,
      ),
    );
  }
}

class _CardViewer extends StatelessWidget {
  const _CardViewer({
    required this.controller,
    required this.deck,
    required this.size,
    required this.share,
    required this.playerCardIds,
  });

  final PageController controller;
  final List<Card> deck;
  final GameCardSize size;
  final ShowShareDialog share;
  final List<String> playerCardIds;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pop();
      },
      child: SizedBox(
        height: size.height,
        width: MediaQuery.sizeOf(context).width * .9,
        child: PageView.builder(
          clipBehavior: Clip.none,
          controller: controller,
          itemBuilder: (context, i) {
            final index = i % deck.length;
            final card = deck[index];
            return Center(
              child: GestureDetector(
                // Used to ignore taps.
                onTap: () {},
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    TiltBuilder(
                      builder: (context, tilt) => GameCard(
                        key: ValueKey('GameCard$index'),
                        tilt: tilt / 2,
                        size: size,
                        image: card.image,
                        name: card.name,
                        description: card.description,
                        suitName: card.suit.name,
                        power: card.power,
                        isRare: card.rarity,
                      ),
                    ),
                    if (playerCardIds.contains(card.id))
                      Positioned(
                        top: IoFlipSpacing.lg,
                        left: IoFlipSpacing.lg,
                        child: RoundedButton.icon(
                          Icons.share_outlined,
                          onPressed: () => share(card),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
