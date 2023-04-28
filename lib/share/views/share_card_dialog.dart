import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/share/share.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ShareCardDialog extends StatelessWidget {
  const ShareCardDialog({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.card,
    super.key,
  });

  final String twitterShareUrl;
  final String facebookShareUrl;
  final Card card;

  @override
  Widget build(BuildContext context) {
    return ShareDialog(
      twitterShareUrl: twitterShareUrl,
      facebookShareUrl: facebookShareUrl,
      content: _DialogContent(card),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent(this.card);

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: GoRouter.of(context).pop,
          ),
        ),
        const SizedBox(height: TopDashSpacing.xlg),
        GameCard(
          image: card.image,
          name: card.name,
          description: card.description,
          suitName: card.suit.name,
          power: card.power,
        ),
        const SizedBox(height: TopDashSpacing.xlg),
        Text(
          card.name,
          style: TopDashTextStyles.mobileH4,
        ),
        Text(card.description, style: TopDashTextStyles.bodyLG),
      ],
    );
  }
}
