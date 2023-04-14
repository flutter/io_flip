import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/views/share_card_dialog.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef ShowShareDialog = Future<void> Function(Card card);

class CardInspector extends StatefulWidget {
  const CardInspector({
    required this.deck,
    required this.playerCardIds,
    required this.startingIndex,
    super.key,
  });

  factory CardInspector.routeBuilder(_, GoRouterState state) {
    final data = state.extra as CardInspectorData?;
    return CardInspector(
      deck: data?.deck ?? [],
      playerCardIds: data?.playerCardIds ?? [],
      startingIndex: data?.startingIndex ?? 0,
    );
  }

  final List<String> playerCardIds;
  final List<Card> deck;
  final int startingIndex;

  @override
  State<CardInspector> createState() => _CardInspectorState();
}

class _CardInspectorState extends State<CardInspector> {
  late final start = widget.deck.length * 300 + widget.startingIndex;
  late final PageController controller = PageController(initialPage: start);

  Future<void> _shareDialog(Card card) {
    final shareResource = context.read<ShareResource>();
    final twitterLink = shareResource.twitterShareCardUrl(card.id);
    final facebookLink = shareResource.twitterShareCardUrl(card.id);
    return showDialog(
      context: context,
      builder: (context) => ShareCardDialog(
        twitterShareUrl: twitterLink,
        facebookShareUrl: facebookLink,
        card: card,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const transitionDuration = Duration(milliseconds: 200);
    return Scaffold(
      backgroundColor: TopDashColors.seedScrim,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: TopDashSpacing.lg,
                right: TopDashSpacing.xlg,
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
          ),
          Flexible(
            child: ResponsiveLayoutBuilder(
              small: (_, __) => _PortraitCardViewer(
                key: const Key('PortraitCardViewer'),
                deck: widget.deck,
                transitionDuration: transitionDuration,
                share: _shareDialog,
                size: const Size(327, 435),
                startingIndex: widget.startingIndex,
                controller: controller,
                playerCardIds: widget.playerCardIds,
              ),
              large: (_, __) => _LandscapeCardViewer(
                key: const Key('LandscapeCardViewer'),
                deck: widget.deck,
                transitionDuration: transitionDuration,
                share: _shareDialog,
                size: const Size(327, 435),
                startingIndex: widget.startingIndex,
                controller: controller,
                playerCardIds: widget.playerCardIds,
              ),
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

class _PortraitCardViewer extends StatelessWidget {
  const _PortraitCardViewer({
    required this.deck,
    required this.transitionDuration,
    required this.share,
    required this.startingIndex,
    required this.size,
    required this.controller,
    required this.playerCardIds,
    super.key,
  });

  final List<Card> deck;
  final Duration transitionDuration;
  final ShowShareDialog share;
  final Size size;
  final int startingIndex;
  final PageController controller;
  final List<String> playerCardIds;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: _CardViewer(
            controller: controller,
            deck: deck,
            share: share,
            size: size,
            playerCardIds: playerCardIds,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BackButton(
              controller: controller,
              transitionDuration: transitionDuration,
            ),
            _ForwardButton(
              controller: controller,
              transitionDuration: transitionDuration,
            ),
          ],
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: TopDashSpacing.xlg,
            maxHeight: TopDashSpacing.xxxlg,
          ),
        ),
      ],
    );
  }
}

class _LandscapeCardViewer extends StatelessWidget {
  const _LandscapeCardViewer({
    required this.deck,
    required this.transitionDuration,
    required this.share,
    required this.startingIndex,
    required this.size,
    required this.controller,
    required this.playerCardIds,
    super.key,
  });

  final List<Card> deck;
  final Duration transitionDuration;
  final ShowShareDialog share;
  final Size size;
  final int startingIndex;
  final PageController controller;
  final List<String> playerCardIds;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(),
        _BackButton(
          controller: controller,
          transitionDuration: transitionDuration,
        ),
        SizedBox(
          width: size.width + TopDashSpacing.xxxlg,
          child: _CardViewer(
            controller: controller,
            deck: deck,
            size: size,
            share: share,
            playerCardIds: playerCardIds,
          ),
        ),
        _ForwardButton(
          controller: controller,
          transitionDuration: transitionDuration,
        ),
        const Spacer(),
      ],
    );
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
    return IconButton(
      icon: const Icon(Icons.arrow_forward_ios),
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
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
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
  final Size size;
  final ShowShareDialog share;
  final List<String> playerCardIds;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemBuilder: (context, i) {
        final index = i % deck.length;
        final card = deck[index];
        return Center(
          child: Stack(
            children: [
              GameCard(
                key: ValueKey('GameCard$index'),
                width: size.width,
                height: size.height,
                image: card.image,
                name: card.name,
                suitName: card.suit.name,
                power: card.power,
              ),
              if (playerCardIds.contains(card.id))
                Positioned(
                  top: TopDashSpacing.lg,
                  left: TopDashSpacing.lg,
                  child: RoundedButton.icon(
                    const Icon(Icons.share_outlined),
                    onPressed: () => share(card),
                    backgroundColor: TopDashColors.seedWhite,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class CardInspectorData extends Equatable {
  const CardInspectorData({
    required this.playerCardIds,
    required this.deck,
    this.startingIndex = 0,
  });
  final List<Card> deck;
  final List<String> playerCardIds;
  final int startingIndex;

  @override
  List<Object?> get props => [deck, playerCardIds, startingIndex];
}
