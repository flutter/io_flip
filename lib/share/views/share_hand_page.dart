import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/share/views/views.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ShareHandPage extends StatelessWidget {
  const ShareHandPage({
    super.key,
    required this.initials,
    required this.wins,
    required this.deckId,
  });

  factory ShareHandPage.routeBuilder(_, GoRouterState state) {
    final data = state.extra as SharePageData?;
    return ShareHandPage(
      key: const Key('share_hand_page'),
      initials: data?.initials ?? '',
      wins: data?.wins ?? 0,
      deckId: data?.deckId ?? '',
    );
  }
  final String initials;
  final int wins;
  final String deckId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: TopDashSpacing.xlg),
          const IoFlipLogo(width: 96.96, height: 64),
          const Spacer(),
          Text(
            l10n.shareTeamTitle,
            style: TopDashTextStyles.mobileH1,
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          Align(
            alignment: Alignment.topCenter,
            child: CardFan(),
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
          Row(
            children: [
              const SizedBox(width: TopDashSpacing.lg),
              const _MusicButton(),
              const Spacer(),
              const SizedBox(width: TopDashSpacing.sm),
              RoundedButton.text(
                l10n.shareButtonLabel,
                onPressed: () => _shareDialog(context, []),
              ),
              const SizedBox(width: TopDashSpacing.sm),
              RoundedButton.text(
                l10n.mainMenuButtonLabel,
                backgroundColor: TopDashColors.seedBlack,
                foregroundColor: TopDashColors.seedWhite,
                borderColor: TopDashColors.seedPaletteNeutral40,
                onPressed: () => GoRouter.of(context).go('/'),
              ),
              const SizedBox(width: TopDashSpacing.sm),
              const Spacer(),
              RoundedButton.icon(
                Icons.info,
                // TODO(Samobrien): Route to FAQ Page
              ),
              const SizedBox(width: TopDashSpacing.lg),
            ],
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

class _MusicButton extends StatelessWidget {
  const _MusicButton();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return ValueListenableBuilder<bool>(
      valueListenable: settings.musicOn,
      builder: (context, musicOn, child) => RoundedButton.icon(
        musicOn ? Icons.volume_up : Icons.volume_off,
        onPressed: settings.toggleMusicOn,
      ),
    );
  }
}

class SharePageData extends Equatable {
  const SharePageData({
    required this.initials,
    required this.wins,
    required this.deckId,
  });
  final String initials;
  final int wins;
  final String deckId;

  @override
  List<Object> get props => [wins, initials, deckId];
}
