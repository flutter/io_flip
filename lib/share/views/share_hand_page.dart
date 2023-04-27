import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/audio/audio.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/info/info.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/share/views/views.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash/utils/utils.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ShareHandPage extends StatelessWidget {
  const ShareHandPage({
    required this.initials,
    required this.wins,
    required this.deckId,
    required this.deck,
    super.key,
  });

  factory ShareHandPage.routeBuilder(_, GoRouterState state) {
    final data = state.extra as ShareHandPageData?;
    return ShareHandPage(
      key: const Key('share_hand_page'),
      initials: data?.initials ?? '',
      wins: data?.wins ?? 0,
      deckId: data?.deckId ?? '',
      deck: data?.deck ?? [],
    );
  }

  final String initials;
  final int wins;
  final String deckId;
  final List<Card> deck;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return IoFlipScaffold(
      body: Column(
        children: [
          const SizedBox(height: TopDashSpacing.xlg),
          IoFlipLogo(width: 96.96, height: 64),
          const Spacer(),
          Text(
            l10n.shareTeamTitle,
            style: TopDashTextStyles.mobileH1,
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          Align(
            alignment: Alignment.topCenter,
            child: CardFan(
              deck: deck,
            ),
          ),
          Text(
            initials,
            style: TopDashTextStyles.mobileH1,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
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
          const Spacer(),
          IoFlipBottomBar(
            leading: const AudioToggleButton(),
            middle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundedButton.text(
                  l10n.shareButtonLabel,
                  onPressed: () => _shareDialog(context, deck),
                ),
                const SizedBox(width: TopDashSpacing.sm),
                RoundedButton.text(
                  l10n.mainMenuButtonLabel,
                  backgroundColor: TopDashColors.seedBlack,
                  foregroundColor: TopDashColors.seedWhite,
                  borderColor: TopDashColors.seedPaletteNeutral40,
                  onPressed: () => GoRouter.of(context).go('/'),
                ),
              ],
            ),
            trailing: RoundedButton.svg(
              key: const Key('share_page_info_button'),
              Assets.icons.info,
              onPressed: () => TopDashDialog.show(
                context,
                child: const InfoView(),
                onClose: context.maybePop,
              ),
            ),
          ),
          const SizedBox(height: TopDashSpacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Text(
                  l10n.ioLinkLabel,
                  style: TopDashTextStyles.bodyMD.copyWith(
                    color: TopDashColors.seedGrey90,
                  ),
                ),
                // TODO(Samobrien): Route to Google I/O web page
              ),
              const SizedBox(width: TopDashSpacing.md),
              GestureDetector(
                child: Text(
                  l10n.howItsMadeLinkLabel,
                  style: TopDashTextStyles.bodyMD.copyWith(
                    color: TopDashColors.seedGrey90,
                  ),
                ),
                // TODO(Samobrien): Route to how it's made web page
              ),
            ],
          ),
          const SizedBox(height: TopDashSpacing.xlg),
        ],
      ),
    );
  }

  Future<void> _shareDialog(BuildContext context, List<Card> cards) {
    return showDialog(
      context: context,
      builder: (context) => ShareHandDialog(
        cards: cards,
        deckId: deckId,
        initials: initials,
        wins: wins,
      ),
    );
  }
}

class ShareHandPageData extends Equatable {
  const ShareHandPageData({
    required this.initials,
    required this.wins,
    required this.deckId,
    required this.deck,
  });
  final String initials;
  final int wins;
  final String deckId;
  final List<Card> deck;

  @override
  List<Object> get props => [wins, initials, deckId];
}
