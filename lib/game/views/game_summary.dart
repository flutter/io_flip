import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/game/views/card_inspector.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef RouterNeglectCall = void Function(BuildContext, VoidCallback);

class GameSummaryView extends StatelessWidget {
  const GameSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const IoFlipScaffold(
      body: Stack(
        children: [
          Align(
            child: _MatchSummaryScreenView(key: Key('match_summary_view')),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              child: GameSummaryFooter(key: Key('match summary footer')),
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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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

    switch (bloc.gameResult()) {
      case GameResult.win:
        title = context.l10n.gameWonTitle;
        color = TopDashColors.seedBlue;
        break;
      case GameResult.lose:
        color = TopDashColors.seedPaletteRed40;
        title = context.l10n.gameLostTitle;
        break;
      case GameResult.draw:
        color = TopDashColors.seedGrey50;
        title = context.l10n.gameTiedTitle;
        break;
      case null:
        return Center(child: Text(context.l10n.gameResultError));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TopDashTextStyles.mobileH1,
        ),
        Text(
          context.l10n.gameSummaryStreak(state.playerScoreCard.currentStreak),
          style: TopDashTextStyles.mobileH6.copyWith(color: color),
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

    final hostCardsOrdered = state.matchState.hostPlayedCards.map(
      (id) => state.match.hostDeck.cards.firstWhere((card) => card.id == id),
    );
    final guestCardsOrdered = state.matchState.guestPlayedCards.map(
      (id) => state.match.guestDeck.cards.firstWhere((card) => card.id == id),
    );

    final playerCards =
        (bloc.isHost ? hostCardsOrdered : guestCardsOrdered).map(
      (card) => GameCard(
        size: const GameCardSize.sm(),
        image: card.image,
        name: card.name,
        description: card.description,
        power: card.power,
        suitName: card.suit.name,
        overlay: bloc.isWinningCard(card, isPlayer: true),
        isRare: card.rarity,
      ),
    );

    final opponentCards =
        (bloc.isHost ? guestCardsOrdered : hostCardsOrdered).map(
      (card) => GameCard(
        size: const GameCardSize.sm(),
        image: card.image,
        name: card.name,
        description: card.description,
        power: card.power,
        suitName: card.suit.name,
        overlay: bloc.isWinningCard(card, isPlayer: false),
        isRare: card.rarity,
      ),
    );

    final cards = bloc.isHost
        ? [...hostCardsOrdered, ...guestCardsOrdered]
        : [...guestCardsOrdered, ...hostCardsOrdered];

    final playerCardIds = bloc.isHost
        ? state.matchState.hostPlayedCards
        : state.matchState.guestPlayedCards;
    final gameCards = [...playerCards, ...opponentCards];
    return Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          minHeight: 360,
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: TopDashSpacing.md,
          ),
          shrinkWrap: true,
          itemCount: gameCards.length,
          itemBuilder: (context, index) => GestureDetector(
            child: gameCards[index],
            onTap: () => GoRouter.of(context).pushNamed(
              'card_inspector',
              extra: CardInspectorData(
                deck: cards,
                playerCardIds: playerCardIds,
                startingIndex: index,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameSummaryFooter extends StatelessWidget {
  const GameSummaryFooter({
    RouterNeglectCall routerNeglectCall = Router.neglect,
    super.key,
  }) : _routerNeglectCall = routerNeglectCall;

  final RouterNeglectCall _routerNeglectCall;

  static const Widget _gap = SizedBox(width: TopDashSpacing.md);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<GameBloc>();
    final state = bloc.state as MatchLoadedState;
    final playerScoreCard = state.playerScoreCard;

    return Padding(
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
            onPressed: () => QuitGameDialog.show(
              context,
              onConfirm: () => _routerNeglectCall(context, () {
                if (playerScoreCard.initials != null) {
                  GoRouter.of(context).go('/');
                } else {
                  GoRouter.of(context).pop();
                  bloc.add(const LeaderboardEntryRequested());
                }
              }),
              onCancel: GoRouter.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }
}
