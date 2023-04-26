import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/audio/audio.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef RouterNeglectCall = void Function(BuildContext, VoidCallback);

class MatchMakingView extends StatelessWidget {
  const MatchMakingView({
    required this.deck,
    super.key,
    Future<void> Function(ClipboardData) setClipboardData = Clipboard.setData,
    RouterNeglectCall routerNeglectCall = Router.neglect,
  })  : _setClipboardData = setClipboardData,
        _routerNeglectCall = routerNeglectCall;

  final Future<void> Function(ClipboardData) _setClipboardData;
  final List<Card> deck;
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
        if (state.status == MatchMakingStatus.processing ||
            state.status == MatchMakingStatus.initial) {
          return ResponsiveLayoutBuilder(
            small: (_, __) => _WaitingForMatchView(
              deck: deck,
              setClipboardData: _setClipboardData,
              inviteCode: state.match?.inviteCode,
              title: TopDashTextStyles.mobileH4Light,
              subtitle: TopDashTextStyles.mobileH6Light,
              key: const Key('small_waiting_for_match_view'),
            ),
            large: (_, __) => _WaitingForMatchView(
              deck: deck,
              setClipboardData: _setClipboardData,
              inviteCode: state.match?.inviteCode,
              title: TopDashTextStyles.headlineH4Light,
              subtitle: TopDashTextStyles.headlineH6Light,
              key: const Key('large_waiting_for_match_view'),
            ),
          );
        }

        if (state.status == MatchMakingStatus.timeout) {
          return const IoFlipScaffold(
            body: Center(
              child: Text('Match making timed out, sorry!'),
            ),
          );
        }

        if (state.status == MatchMakingStatus.failed) {
          return const IoFlipScaffold(
            body: Center(
              child: Text('Match making failed, sorry!'),
            ),
          );
        }

        final l10n = context.l10n;
        return IoFlipScaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.getReadyToFlip,
                  style: TopDashTextStyles.mobileH1,
                ),
                const SizedBox(height: TopDashSpacing.xlg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    l10n.aiGameByGoogle,
                    style: TopDashTextStyles.mobileH4Light,
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
    required this.deck,
    required this.setClipboardData,
    this.inviteCode,
    super.key,
  });
  final List<Card> deck;
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
                    const SizedBox(height: TopDashSpacing.xxlg),
                    const FadingDotLoader(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final card in deck)
                          Padding(
                            padding: const EdgeInsets.all(TopDashSpacing.xs),
                            child: Stack(
                              children: [
                                GameCard(
                                  size: const GameCardSize.xs(),
                                  image: card.image,
                                  name: card.name,
                                  description: card.description,
                                  suitName: card.suit.name,
                                  power: card.power,
                                ),
                                Positioned(
                                  bottom: TopDashSpacing.xs + 2,
                                  right: TopDashSpacing.xs,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: TopDashColors.seedWhite,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 2,
                                        color: TopDashColors.seedBlack,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(-2, 2),
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.add, size: 32),
                                  ),
                                ),
                              ],
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
              backgroundColor: TopDashColors.seedGrey50,
              foregroundColor: TopDashColors.seedGrey70,
            ),
          ),
        ],
      ),
    );
  }
}
