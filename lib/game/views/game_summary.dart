import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/bloc/game_bloc.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/widgets/game_card.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameSummaryView extends StatelessWidget {
  const GameSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopDashColors.backgroundMain,
      body: Stack(
        children: const [
          Align(
            child: _MatchSummaryScreenView(key: Key('match_summary_view')),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              child: _Footer(key: Key('match summary footer')),
            ),
          )
        ],
      ),
    );
  }
}

class _MatchSummaryScreenView extends StatelessWidget {
  const _MatchSummaryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxWidth < constraints.maxHeight ||
            constraints.maxWidth < 1150;
        return isPortrait
            ? const PortraitSummaryView()
            : const LandscapeSummaryView();
      },
    );
  }
}

class PortraitSummaryView extends StatelessWidget {
  const PortraitSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _ResultView(key: Key('game_summary_result_view')),
        SizedBox(height: TopDashSpacing.xxlg),
        _CardsView(),
      ],
    );
  }
}

class LandscapeSummaryView extends StatelessWidget {
  const LandscapeSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _ResultView(key: Key('game_summary_result_view')),
        _CardsView(),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final state = bloc.state as MatchLoadedState;
    late final String title;
    late final Color color;

    if ((bloc.isHost && state.matchState.result == MatchResult.host) ||
        (!bloc.isHost && state.matchState.result == MatchResult.guest)) {
      title = context.l10n.gameWonTitle;
      color = TopDashColors.darkPen;
    } else if ((bloc.isHost && state.matchState.result == MatchResult.guest) ||
        (!bloc.isHost && state.matchState.result == MatchResult.host)) {
      color = Colors.red;
      title = context.l10n.gameLostTitle;
    } else {
      color = TopDashColors.drawGrey;
      title = context.l10n.gameTiedTitle;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 48, color: color),
        ),
        Text(
          context.l10n.gameSummaryStreak(state.playerScoreCard.currentStreak),
          style: TextStyle(fontSize: 20, color: color),
        ),
      ],
    );
  }
}

class _CardsView extends StatelessWidget {
  const _CardsView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final state = bloc.state as MatchLoadedState;

    final hostCards = List.generate(state.match.hostDeck.cards.length, (index) {
      final card = state.match.hostDeck.cards[index];
      return GameCard(
        width: 120,
        height: 180,
        card: card,
        overlay: bloc.isWiningCard(card, isPlayer: bloc.isHost)
            ? CardOverlayType.win
            : CardOverlayType.lose,
      );
    });

    final guestCards =
        List.generate(state.match.guestDeck.cards.length, (index) {
      final card = state.match.guestDeck.cards[index];
      return GameCard(
        width: 120,
        height: 180,
        card: card,
        overlay: bloc.isWiningCard(card, isPlayer: !bloc.isHost)
            ? CardOverlayType.win
            : CardOverlayType.lose,
      );
    });

    return Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          minHeight: 360,
        ),
        child: GridView.count(
          shrinkWrap: true,
          mainAxisSpacing: TopDashSpacing.md,
          crossAxisCount: 3,
          children: bloc.isHost
              ? [...guestCards, ...hostCards]
              : [...hostCards, ...guestCards],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  static const Widget _gap = SizedBox(width: TopDashSpacing.md);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton.text(
              l10n.nextMatch,
              onPressed: () => GoRouter.of(context).pop(),
            ),
            _gap,
            RoundedButton.text(
              l10n.quit,
              backgroundColor: Colors.white,
              onPressed: () => GoRouter.of(context).go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
