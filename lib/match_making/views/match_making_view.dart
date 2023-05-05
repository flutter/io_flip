import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class MatchMakingView extends StatelessWidget {
  const MatchMakingView({
    required this.cards,
    super.key,
    Future<void> Function(ClipboardData) setClipboardData = Clipboard.setData,
    RouterNeglectCall routerNeglectCall = Router.neglect,
  })  : _setClipboardData = setClipboardData,
        _routerNeglectCall = routerNeglectCall;

  final Future<void> Function(ClipboardData) _setClipboardData;
  final List<Card> cards;
  final RouterNeglectCall _routerNeglectCall;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchMakingBloc, MatchMakingState>(
      listener: (previous, current) {
        if (current.status == MatchMakingStatus.completed) {
          Future.delayed(
            const Duration(seconds: 3),
            () => _routerNeglectCall(
              context,
              () => context.goNamed(
                'game',
                extra: GamePageData(
                  isHost: current.isHost,
                  matchId: current.match?.id ?? '',
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final l10n = context.l10n;
        if (state.status == MatchMakingStatus.processing ||
            state.status == MatchMakingStatus.initial) {
          return ResponsiveLayoutBuilder(
            small: (_, __) => _WaitingForMatchView(
              cards: cards,
              setClipboardData: _setClipboardData,
              inviteCode: state.match?.inviteCode,
              title: IoFlipTextStyles.mobileH4Light,
              subtitle: IoFlipTextStyles.mobileH6Light,
              key: const Key('small_waiting_for_match_view'),
            ),
            large: (_, __) => _WaitingForMatchView(
              cards: cards,
              setClipboardData: _setClipboardData,
              inviteCode: state.match?.inviteCode,
              title: IoFlipTextStyles.headlineH4Light,
              subtitle: IoFlipTextStyles.headlineH6Light,
              key: const Key('large_waiting_for_match_view'),
            ),
          );
        }

        if (state.status == MatchMakingStatus.timeout) {
          return IoFlipScaffold(
            body: IoFlipErrorView(
              text: 'Match making timed out, sorry!',
              buttonText: l10n.playAgain,
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
          );
        }

        if (state.status == MatchMakingStatus.failed) {
          return IoFlipScaffold(
            body: IoFlipErrorView(
              text: 'Match making failed, sorry!',
              buttonText: l10n.playAgain,
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
          );
        }

        return IoFlipScaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.getReadyToFlip,
                  style: IoFlipTextStyles.mobileH1,
                ),
                const SizedBox(height: IoFlipSpacing.xlg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    l10n.aiGameByGoogle,
                    style: IoFlipTextStyles.mobileH4Light,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WaitingForMatchView extends StatelessWidget {
  const _WaitingForMatchView({
    required this.title,
    required this.subtitle,
    required this.cards,
    required this.setClipboardData,
    this.inviteCode,
    super.key,
  });
  final List<Card> cards;
  final String? inviteCode;
  final Future<void> Function(ClipboardData) setClipboardData;
  final TextStyle title;
  final TextStyle subtitle;

  @override
  Widget build(BuildContext context) {
    return IoFlipScaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 600),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      context.l10n.findingMatch,
                      style: title,
                    ),
                    if (inviteCode == null)
                      Text(
                        context.l10n.searchingForOpponents,
                        style: subtitle,
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          final code = inviteCode;
                          if (code != null) {
                            setClipboardData(ClipboardData(text: code));
                          }
                        },
                        child: Text(context.l10n.copyInviteCode),
                      ),
                    const SizedBox(height: IoFlipSpacing.xxlg),
                    const FadingDotLoader(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final card in cards)
                          Padding(
                            padding: const EdgeInsets.all(IoFlipSpacing.xs),
                            child: GameCard(
                              size: const GameCardSize.xs(),
                              image: card.image,
                              name: card.name,
                              description: card.description,
                              suitName: card.suit.name,
                              power: card.power,
                              isRare: card.rarity,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          IoFlipBottomBar(
            leading: const AudioToggleButton(),
            middle: RoundedButton.text(
              context.l10n.matchmaking,
              backgroundColor: IoFlipColors.seedGrey50,
              foregroundColor: IoFlipColors.seedGrey70,
            ),
          ),
        ],
      ),
    );
  }
}
