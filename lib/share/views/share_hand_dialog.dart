import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/share/widgets/widgets.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class ShareHandDialog extends StatelessWidget {
  const ShareHandDialog({
    required this.wins,
    required this.initials,
    required this.deck,
    super.key,
  });

  final Deck deck;
  final int wins;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final shareResource = context.watch<ShareResource>();
    final twitterLink = shareResource.twitterShareHandUrl(deck.id);
    final facebookLink = shareResource.facebookShareHandUrl(deck.id);
    return ShareDialog(
      twitterShareUrl: twitterLink,
      facebookShareUrl: facebookLink,
      downloadCards: deck.cards,
      downloadDeck: deck,
      content: _DialogContent(
        cards: deck.cards,
        wins: wins,
        initials: initials,
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent({
    required this.cards,
    required this.wins,
    required this.initials,
  });

  final List<Card> cards;
  final int wins;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(IoFlipSpacing.lg),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CardFan(cards: cards),
          ),
        ),
        const SizedBox(height: IoFlipSpacing.lg),
        Text(
          l10n.shareTeamDialogDescription,
          style: IoFlipTextStyles.mobileH4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: IoFlipSpacing.lg),
        Text(
          initials,
          style: IoFlipTextStyles.mobileH1,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.tempPreferencesCustom.path,
              color: IoFlipColors.seedGreen,
            ),
            const SizedBox(width: IoFlipSpacing.sm),
            Text(
              '$wins ${l10n.winStreakLabel}',
              style: IoFlipTextStyles.mobileH6
                  .copyWith(color: IoFlipColors.seedGreen),
            ),
          ],
        ),
      ],
    );
  }
}
