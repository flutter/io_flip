import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/audio/audio.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/gen/assets.gen.dart';
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
    final isPhoneWidth = MediaQuery.sizeOf(context).width < 400;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return IoFlipScaffold(
      body: MatchResultSplash(
        result: result ?? GameResult.draw,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isPhoneWidth && screenHeight > 610)
              Padding(
                padding: const EdgeInsets.only(top: TopDashSpacing.lg),
                child: IoFlipLogo(
                  height: 97,
                  width: 64,
                ),
              )
            else if (screenHeight > 660)
              Padding(
                padding: const EdgeInsets.only(top: TopDashSpacing.md),
                child: IoFlipLogo(
                  height: 88,
                  width: 133,
                ),
              ),
            const Spacer(),
            const SizedBox(height: TopDashSpacing.sm),
            const _ResultView(),
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: _CardsView(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(TopDashSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const AudioToggleButton(),
                  const Spacer(),
                  GameSummaryFooter(isPhoneWidth: isPhoneWidth),
                  const Spacer(),
                  const InfoButton(),
                ],
              ),
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

    switch (bloc.gameResult()) {
      case GameResult.win:
        title = context.l10n.gameWonTitle;
        break;
      case GameResult.lose:
        title = context.l10n.gameLostTitle;
        break;
      case GameResult.draw:
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.images.tempPreferencesCustom.path,
              color: TopDashColors.seedYellow,
            ),
            const SizedBox(width: TopDashSpacing.sm),
            Text(
              context.l10n
                  .gameSummaryStreak(state.playerScoreCard.currentStreak),
              style: TopDashTextStyles.mobileH6
                  .copyWith(color: TopDashColors.seedYellow),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardsView extends StatelessWidget {
  const _CardsView();

  @override
  Widget build(BuildContext context) {
    final cardSize = (MediaQuery.sizeOf(context).height > 700)
        ? const GameCardSize.sm()
        : const GameCardSize.xs();
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
            size: cardSize,
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
            size: cardSize,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
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
    final score = '${playerCard.power} - ${opponentCard.power}';
    switch (playerCard.overlay) {
      case CardOverlayType.win:
        result = 'W $score';
        break;
      case CardOverlayType.lose:
        result = 'L $score';
        break;
      case CardOverlayType.draw:
        result = 'D $score';
        break;
      case null:
        result = score;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TopDashSpacing.sm,
        vertical: TopDashSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(onTap: () => onTap(0), child: playerCard),
          const SizedBox(height: TopDashSpacing.md),
          GestureDetector(onTap: () => onTap(3), child: opponentCard),
          const SizedBox(height: TopDashSpacing.md),
          Text(
            result,
            style: TopDashTextStyles.bodyLG.copyWith(
              color: TopDashColors.seedWhite,
            ),
          )
        ],
      ),
    );
  }
}

class GameSummaryFooter extends StatelessWidget {
  const GameSummaryFooter({
    required this.isPhoneWidth,
    RouterNeglectCall routerNeglectCall = Router.neglect,
    super.key,
  }) : _routerNeglectCall = routerNeglectCall;

  final RouterNeglectCall _routerNeglectCall;
  final bool isPhoneWidth;

  static const Widget _gap =
      SizedBox(width: TopDashSpacing.md, height: TopDashSpacing.md);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;
    final playerScoreCard = state.playerScoreCard;
    final playerDeck =
        bloc.isHost ? state.match.hostDeck : state.match.guestDeck;
    final children = [
      RoundedButton.text(
        l10n.nextMatch,
        onPressed: () => GoRouter.of(context).pop(),
      ),
      _gap,
      RoundedButton.text(
        l10n.quit,
        backgroundColor: TopDashColors.seedBlack,
        foregroundColor: TopDashColors.seedWhite,
        borderColor: TopDashColors.seedPaletteNeutral40,
        onPressed: () => TopDashDialog.show(
          context,
          child: QuitGameDialog(
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
      ),
    ];
    if (isPhoneWidth) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
  }
}
