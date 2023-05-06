import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/info/info.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class GameSummaryView extends StatelessWidget {
  const GameSummaryView({super.key, this.isWeb = kIsWeb});

  final bool isWeb;
  static const _gap = SizedBox(width: IoFlipSpacing.sm);

  @override
  Widget build(BuildContext context) {
    final result = context.select((GameBloc bloc) => bloc.gameResult());
    final audio = context.read<AudioController>();
    switch (result) {
      case GameResult.win:
        audio.playSfx(Assets.sfx.winMatch);
        break;
      case GameResult.lose:
        audio.playSfx(Assets.sfx.lostMatch);
        break;
      case GameResult.draw:
      case null:
        audio.playSfx(Assets.sfx.drawMatch);
    }
    final isPhoneWidth = MediaQuery.sizeOf(context).width < 400;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return IoFlipScaffold(
      body: MatchResultSplash(
        isWeb: isWeb,
        result: result ?? GameResult.draw,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isPhoneWidth && screenHeight > 610)
              Padding(
                padding: const EdgeInsets.only(top: IoFlipSpacing.lg),
                child: IoFlipLogo(
                  height: 97,
                  width: 64,
                ),
              )
            else if (screenHeight > 660)
              Padding(
                padding: const EdgeInsets.only(top: IoFlipSpacing.md),
                child: IoFlipLogo(
                  height: 88,
                  width: 133,
                ),
              ),
            const Spacer(),
            const SizedBox(height: IoFlipSpacing.sm),
            const _ResultView(),
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: _CardsView(),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(IoFlipSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AudioToggleButton(),
                  _gap,
                  Expanded(
                    child: GameSummaryFooter(),
                  ),
                  _gap,
                  InfoButton(),
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
          style: IoFlipTextStyles.mobileH1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.images.tempPreferencesCustom.path,
              color: IoFlipColors.seedYellow,
            ),
            const SizedBox(width: IoFlipSpacing.sm),
            Text(
              context.l10n
                  .gameSummaryStreak(state.playerScoreCard.latestStreak),
              style: IoFlipTextStyles.mobileH6
                  .copyWith(color: IoFlipColors.seedYellow),
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
          onTap: (card) => IoFlipDialog.show(
            context,
            isTransparent: true,
            child: CardInspectorDialog(
              playerCardIds: playerCardIds,
              deck: cards,
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
        horizontal: IoFlipSpacing.sm,
        vertical: IoFlipSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(onTap: () => onTap(0), child: playerCard),
          const SizedBox(height: IoFlipSpacing.md),
          GestureDetector(onTap: () => onTap(3), child: opponentCard),
          const SizedBox(height: IoFlipSpacing.md),
          Text(
            result,
            style: IoFlipTextStyles.bodyLG.copyWith(
              color: IoFlipColors.seedWhite,
            ),
          )
        ],
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;
    final playerDeck =
        bloc.isHost ? state.match.hostDeck : state.match.guestDeck;
    final result = state.matchState.result;
    final showNextMatch = (result == MatchResult.host && bloc.isHost) ||
        (result == MatchResult.guest && !bloc.isHost) ||
        result == MatchResult.draw;

    return Wrap(
      spacing: IoFlipSpacing.sm,
      runSpacing: IoFlipSpacing.sm,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        if (showNextMatch)
          RoundedButton.text(
            l10n.nextMatch,
            onPressed: () => _routerNeglectCall(
              context,
              () => GoRouter.of(context).goNamed(
                'match_making',
                extra: MatchMakingPageData(deck: bloc.playerDeck),
              ),
            ),
          ),
        RoundedButton.text(
          l10n.submitScore,
          backgroundColor: IoFlipColors.seedBlack,
          foregroundColor: IoFlipColors.seedWhite,
          borderColor: IoFlipColors.seedPaletteNeutral40,
          onPressed: () {
            final router = GoRouter.of(context);
            final event = LeaderboardEntryRequested(
              shareHandPageData: ShareHandPageData(
                initials: '',
                wins: state.playerScoreCard.latestStreak,
                deckId: playerDeck.id,
                deck: bloc.playerCards,
              ),
            );

            if (showNextMatch) {
              IoFlipDialog.show(
                context,
                child: QuitGameDialog(
                  onConfirm: () => _routerNeglectCall(
                    context,
                    () {
                      router.pop();
                      bloc.add(event);
                    },
                  ),
                  onCancel: router.pop,
                ),
              );
            } else {
              bloc.add(event);
            }
          },
        ),
      ],
    );
  }
}
