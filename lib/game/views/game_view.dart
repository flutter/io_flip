import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        late final Widget child;

        if (state is MatchLoadingState) {
          child = const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MatchLoadFailedState) {
          child = const Center(
            child: Text('Unable to join game!'),
          );
        }

        if (state is MatchLoadedState) {
          child = const _GameBoard();
        }

        if (state is OpponentAbsentState) {
          child = const Center(
            child: Text('Opponent left the game!'),
          );
        }

        return Scaffold(
          backgroundColor: TopDashColors.backgroundMain,
          body: child,
        );
      },
    );
  }
}

class _GameBoard extends StatelessWidget {
  const _GameBoard();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;

    final playerDeck =
        bloc.isHost ? state.match.hostDeck : state.match.guestDeck;

    final opponentDeck =
        bloc.isHost ? state.match.guestDeck : state.match.hostDeck;

    String? playerLastPlayedCard;
    String? opponentLastPlayedCard;

    if (state.turns.isNotEmpty) {
      final lastTurn = state.turns.last;

      playerLastPlayedCard = lastTurn.playerCardId;
      opponentLastPlayedCard = lastTurn.opponentCardId;
    }

    final allPlayerPlayedCards =
        state.turns.map((turn) => turn.playerCardId).toList();
    final allOpponentPlayedCards =
        state.turns.map((turn) => turn.opponentCardId).toList();

    final query = MediaQuery.of(context);

    final cardWidth = query.size.width * .25;
    final cardHeight = cardWidth * 1.4;

    final opponentCardWidth = cardWidth * .8;
    final opponentCardHeight = cardHeight * .8;

    return Center(
      child: Column(
        children: [
          Expanded(
            child: Text('Score: ${state.playerScoreCard.wins} '
                'Streak: ${state.playerScoreCard.longestStreak}'),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final card in opponentDeck.cards)
                    Transform.translate(
                      offset: Offset(
                        0,
                        card.id == opponentLastPlayedCard ? 16 : 0,
                      ),
                      child: allOpponentPlayedCards.contains(card.id) &&
                              state.isCardTurnComplete(card)
                          ? Stack(
                              children: [
                                GameCard(
                                  key: Key('opponent_revealed_card_${card.id}'),
                                  card: card,
                                  width: opponentCardWidth,
                                  height: opponentCardHeight,
                                ),
                                if (bloc.isWiningCard(card, isPlayer: false))
                                  Positioned(
                                    key: Key('win_badge_${card.id}'),
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      color: Colors.green,
                                    ),
                                  ),
                              ],
                            )
                          : FlippedGameCard(
                              key: Key('opponent_hidden_card_${card.id}'),
                              width: opponentCardWidth,
                              height: opponentCardHeight,
                            ),
                    ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: _BoardCenter(),
          ),
          Expanded(child: Text(bloc.isPlayerTurn ? 'Your turn' : 'Their turn')),
          Expanded(
            flex: 4,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final card in playerDeck.cards)
                    InkWell(
                      onTap: () {
                        if (!allPlayerPlayedCards.contains(card.id) &&
                            bloc.canPlayerPlay(card.id) &&
                            !state.playerPlayed) {
                          context.read<GameBloc>().add(PlayerPlayed(card.id));
                        }
                      },
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          card.id == playerLastPlayedCard ? -16 : 0,
                        ),
                        child: Opacity(
                          opacity:
                              allPlayerPlayedCards.contains(card.id) ? .4 : 1,
                          child: Stack(
                            children: [
                              GameCard(
                                key: Key('player_card_${card.id}'),
                                card: card,
                                width: cardWidth,
                                height: cardHeight,
                              ),
                              if (bloc.isWiningCard(card, isPlayer: true))
                                Positioned(
                                  key: Key('win_badge_${card.id}'),
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardCenter extends StatelessWidget {
  const _BoardCenter();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();
    final state = bloc.state;

    if (state is MatchLoadedState) {
      if (state.playerPlayed) {
        return const Align(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (state.matchState.result != null) {
        final result = state.matchState.result == MatchResult.draw
            ? 'Draw'
            : bloc.hasPlayerWon()
                ? 'Win'
                : 'Lose';
        return Center(
          child: Column(
            children: [
              Text('Game ended: $result'),
              const SizedBox(height: TopDashSpacing.sm),
              // TODO(willhlas): add to l10n and update design once ready.
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => GoRouter.of(context).goNamed('share'),
                    icon: const Icon(Icons.share),
                  ),
                  const SizedBox(width: TopDashSpacing.sm),
                  ElevatedButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text('Replay'),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }

    return const SizedBox();
  }
}
