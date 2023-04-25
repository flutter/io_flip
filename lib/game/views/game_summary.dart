import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/audio/audio.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/info/widgets/info_button.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/share/views/card_inspector.dart';
import 'package:top_dash/share/views/share_hand_page.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef RouterNeglectCall = void Function(BuildContext, VoidCallback);

class GameSummaryView extends StatelessWidget {
  const GameSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.select((GameBloc bloc) => bloc.gameResult());
    return IoFlipScaffold(
      body: MatchResultSplash(
        result: result ?? GameResult.draw,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TopDashSpacing.lg),
            if (MediaQuery.of(context).size.height > 600)
              IoFlipLogo(
                height: 104,
                width: 158,
              ),
            const Spacer(),
            const SizedBox(height: TopDashSpacing.lg),
            const _ResultView(),
            const SizedBox(height: TopDashSpacing.xlg),
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: _CardsView(),
            ),
            const Spacer(),
            const IoFlipBottomBar(
              leading: AudioToggleButton(),
              middle: GameSummaryFooter(),
              trailing: InfoButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();
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
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;

    final hostCardsOrdered = state.matchState.hostPlayedCards.map(
      (id) => state.match.hostDeck.cards.firstWhere((card) => card.id == id),
    );
    final guestCardsOrdered = state.matchState.guestPlayedCards.map(
      (id) => state.match.guestDeck.cards.firstWhere((card) => card.id == id),
    );

    final playerCards = (bloc.isHost ? hostCardsOrdered : guestCardsOrdered)
        .map(
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
        )
        .toList();

    final opponentCards = (bloc.isHost ? guestCardsOrdered : hostCardsOrdered)
        .map(
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
        )
        .toList();

    final cards = bloc.isHost
        ? [...hostCardsOrdered, ...guestCardsOrdered]
        : [...guestCardsOrdered, ...hostCardsOrdered];

    final playerCardIds = bloc.isHost
        ? state.matchState.hostPlayedCards
        : state.matchState.guestPlayedCards;

    final roundSummaries = List.generate(
      3,
      (index) => _RoundSummary(
        playerCard: playerCards[index],
        opponentCard: opponentCards[index],
        onTap: (card) => GoRouter.of(context).pushNamed(
          'card_inspector',
          extra: CardInspectorData(
            deck: cards,
            playerCardIds: playerCardIds,
            startingIndex: index + card,
          ),
        ),
      ),
    );

    const divider = SizedBox(
      height: 340,
      width: TopDashSpacing.xxlg,
      child: VerticalDivider(
        color: TopDashColors.seedGrey50,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          roundSummaries[0],
          divider,
          roundSummaries[1],
          divider,
          roundSummaries[2],
        ],
      ),
    );
  }
}

class _RoundSummary extends StatelessWidget {
  const _RoundSummary({
    required this.playerCard,
    required this.opponentCard,
    required this.onTap,
  });
  final GameCard playerCard;
  final GameCard opponentCard;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    String result;
    Color resultColor;
    final score = '${playerCard.power} - ${opponentCard.power}';
    switch (playerCard.overlay) {
      case CardOverlayType.win:
        result = 'W $score';
        resultColor = TopDashColors.seedGreen;
        break;
      case CardOverlayType.lose:
        result = 'L $score';
        resultColor = TopDashColors.seedRed;
        break;
      case CardOverlayType.draw:
        result = 'D $score';
        resultColor = TopDashColors.seedGrey70;
        break;
      case null:
        result = score;
        resultColor = TopDashColors.seedGrey70;
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(onTap: () => onTap(0), child: playerCard),
        const SizedBox(height: TopDashSpacing.lg),
        GestureDetector(onTap: () => onTap(3), child: opponentCard),
        const SizedBox(height: TopDashSpacing.lg),
        Text(
          result,
          style: TopDashTextStyles.bodyLG.copyWith(color: resultColor),
        )
      ],
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
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;
    final playerScoreCard = state.playerScoreCard;
    final playerDeck =
        bloc.isHost ? state.match.hostDeck : state.match.guestDeck;

    return Row(
      mainAxisSize: MainAxisSize.min,
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
                GoRouter.of(context).goNamed(
                  'share_hand',
                  extra: ShareHandPageData(
                    initials: playerScoreCard.initials!,
                    wins: state.playerScoreCard.currentStreak,
                    deckId: playerDeck.id,
                    deck: bloc.playerCards,
                  ),
                );
              } else {
                GoRouter.of(context).pop();
                bloc.add(
                  LeaderboardEntryRequested(
                    shareHandPageData: ShareHandPageData(
                      initials: '',
                      wins: state.playerScoreCard.currentStreak,
                      deckId: playerDeck.id,
                      deck: bloc.playerCards,
                    ),
                  ),
                );
              }
            }),
            onCancel: GoRouter.of(context).pop,
          ),
        ),
      ],
    );
  }
}
