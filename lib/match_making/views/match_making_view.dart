import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/game/views/game_page.dart';
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
          _routerNeglectCall(
            context,
            () => context.goNamed(
              'game',
              extra: GamePageData(
                isHost: current.isHost,
                matchId: current.match?.id ?? '',
                matchConnection: current.matchConnection,
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
              title: TopDashTextStyles.headlineMobileH4Light,
              subtitle: TopDashTextStyles.headlineMobileH6Light,
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
          return const Scaffold(
            backgroundColor: TopDashColors.seedWhite,
            body: Center(
              child: Text('Match making timed out, sorry!'),
            ),
          );
        }

        if (state.status == MatchMakingStatus.failed) {
          return const Scaffold(
            backgroundColor: TopDashColors.seedWhite,
            body: Center(
              child: Text('Match making failed, sorry!'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: TopDashColors.seedWhite,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Host:'),
                Text(state.match?.host ?? ''),
                const Text('Guest:'),
                Text(state.match?.guest ?? ''),
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
    return Scaffold(
      backgroundColor: TopDashColors.seedWhite,
      body: Column(
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
                setClipboardData(
                  ClipboardData(text: inviteCode),
                );
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
                  padding: const EdgeInsets.all(TopDashSpacing.xxs),
                  child: GameCard(
                    height: 150,
                    width: 100,
                    image: card.image,
                    name: card.name,
                    suitName: card.suit.name,
                    power: card.power,
                  ),
                ),
            ],
          ),
          const SizedBox(height: TopDashSpacing.sm),
          RoundedButton.text(
            context.l10n.matchmaking,
            backgroundColor: TopDashColors.seedGrey90,
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
        ],
      ),
    );
  }
}
