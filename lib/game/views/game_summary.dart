import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/bloc/game_bloc.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameSummaryView extends StatelessWidget {
  const GameSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopDashColors.seedWhite,
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
    return ResponsiveLayoutBuilder(
      small: (context, widget) => const PortraitSummaryView(),
      large: (context, widget) => const LandscapeSummaryView(),
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
      color = TopDashColors.seedBlue;
    } else if ((bloc.isHost && state.matchState.result == MatchResult.guest) ||
        (!bloc.isHost && state.matchState.result == MatchResult.host)) {
      color = TopDashColors.seedPaletteRed40;
      title = context.l10n.gameLostTitle;
    } else {
      color = TopDashColors.seedGrey50;
      title = context.l10n.gameTiedTitle;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TopDashTextStyles.headlineMobileH1,
        ),
        Text(
          context.l10n.gameSummaryStreak(state.playerScoreCard.currentStreak),
          style: TopDashTextStyles.headlineMobileH6,
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
        image: card.image,
        name: card.name,
        power: card.power,
        suitName: card.suit.name,
        overlay: bloc.isWinningCard(card, isPlayer: bloc.isHost),
        isRare: card.rarity,
      );
    });

    final guestCards =
        List.generate(state.match.guestDeck.cards.length, (index) {
      final card = state.match.guestDeck.cards[index];
      return GameCard(
        width: 120,
        height: 180,
        image: card.image,
        name: card.name,
        power: card.power,
        suitName: card.suit.name,
        overlay: bloc.isWinningCard(card, isPlayer: !bloc.isHost),
        isRare: card.rarity,
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
      color: TopDashColors.seedWhite,
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
              backgroundColor: TopDashColors.seedWhite,
              onPressed: () => GoRouter.of(context).go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
