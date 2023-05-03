import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/share/bloc/download_bloc.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ShareHandDialog extends StatelessWidget {
  const ShareHandDialog({
    required this.cards,
    required this.wins,
    required this.initials,
    required this.deckId,
    super.key,
  });

  final List<Card> cards;
  final int wins;
  final String initials;
  final String deckId;

  @override
  Widget build(BuildContext context) {
    final shareResource = context.watch<ShareResource>();
    final twitterLink = shareResource.twitterShareHandUrl(deckId);
    final facebookLink = shareResource.facebookShareHandUrl(deckId);
    return ShareDialog(
      twitterShareUrl: twitterLink,
      facebookShareUrl: facebookLink,
      // TODO(Samobrien): add widgets to be downloaded
      downloadRequest: DownloadRequested(card: cards.first),
      content: _DialogContent(
        cards: cards,
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
          padding: const EdgeInsets.all(TopDashSpacing.lg),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CardFan(cards: cards),
          ),
        ),
        const SizedBox(height: TopDashSpacing.lg),
        Text(
          l10n.shareTeamDialogDescription,
          style: TopDashTextStyles.mobileH4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TopDashSpacing.lg),
        Text(
          initials,
          style: TopDashTextStyles.mobileH1,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.tempPreferencesCustom.path,
              color: TopDashColors.seedGreen,
            ),
            const SizedBox(width: TopDashSpacing.sm),
            Text(
              '$wins ${l10n.winStreakLabel}',
              style: TopDashTextStyles.mobileH6
                  .copyWith(color: TopDashColors.seedGreen),
            ),
          ],
        ),
      ],
    );
  }
}
