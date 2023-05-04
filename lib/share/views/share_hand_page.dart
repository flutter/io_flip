import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/info/info.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

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
    final isPhoneWidth = MediaQuery.sizeOf(context).width < 400;

    return IoFlipScaffold(
      body: Column(
        children: [
          const SizedBox(height: IoFlipSpacing.xlg),
          IoFlipLogo(width: 96.96, height: 64),
          const Spacer(),
          Text(
            l10n.shareTeamTitle,
            style: IoFlipTextStyles.mobileH1,
          ),
          const SizedBox(height: IoFlipSpacing.xxlg),
          Align(
            alignment: Alignment.topCenter,
            child: CardFan(cards: deck),
          ),
          Text(
            initials,
            style: IoFlipTextStyles.mobileH1,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: IoFlipSpacing.xlg,
              vertical: IoFlipSpacing.sm,
            ),
            child: Row(
              children: [
                const AudioToggleButton(),
                const Spacer(),
                Flex(
                  direction: isPhoneWidth ? Axis.vertical : Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundedButton.text(
                      l10n.shareButtonLabel,
                      onPressed: () => IoFlipDialog.show(
                        context,
                        child: ShareHandDialog(
                          cards: deck,
                          deckId: deckId,
                          initials: initials,
                          wins: wins,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: IoFlipSpacing.md,
                      height: IoFlipSpacing.md,
                    ),
                    RoundedButton.text(
                      l10n.mainMenuButtonLabel,
                      backgroundColor: IoFlipColors.seedBlack,
                      foregroundColor: IoFlipColors.seedWhite,
                      borderColor: IoFlipColors.seedPaletteNeutral40,
                      onPressed: () => GoRouter.of(context).go('/'),
                    ),
                  ],
                ),
                const Spacer(),
                RoundedButton.svg(
                  key: const Key('share_page_info_button'),
                  Assets.icons.info,
                  onPressed: () => IoFlipDialog.show(
                    context,
                    child: const InfoView(),
                    onClose: context.maybePop,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: IoFlipSpacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Text(
                  l10n.ioLinkLabel,
                  style: IoFlipTextStyles.bodyMD.copyWith(
                    color: IoFlipColors.seedGrey90,
                  ),
                ),
                // TODO(Samobrien): Route to Google I/O web page
              ),
              const SizedBox(width: IoFlipSpacing.md),
              GestureDetector(
                child: Text(
                  l10n.howItsMadeLinkLabel,
                  style: IoFlipTextStyles.bodyMD.copyWith(
                    color: IoFlipColors.seedGrey90,
                  ),
                ),
                // TODO(Samobrien): Route to how it's made web page
              ),
            ],
          ),
          const SizedBox(height: IoFlipSpacing.xlg),
        ],
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
