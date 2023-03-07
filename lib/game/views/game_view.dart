import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:top_dash/widgets/widgets.dart';

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

    final oponentDeck =
        bloc.isHost ? state.match.guestDeck : state.match.hostDeck;

    String? playerLastPlayedCard;
    String? oponentLastPlayedCard;

    if (state.turns.isNotEmpty) {
      final lastTurn = state.turns.last;

      playerLastPlayedCard = lastTurn.playerCardId;
      oponentLastPlayedCard = lastTurn.oponentCardId;
    }

    final allPlayerPlayedCards =
        state.turns.map((turn) => turn.playerCardId).toList();
    final allOponentPlayedCards =
        state.turns.map((turn) => turn.oponentCardId).toList();

    final query = MediaQuery.of(context);

    final cardWidth = query.size.width * .25;
    final cardHeight = cardWidth * 1.4;

    final oponentCardWidth = cardWidth * .8;
    final oponentCardHeight = cardHeight * .8;

    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final card in oponentDeck.cards)
                    Transform.translate(
                      offset: Offset(
                        0,
                        card.id == oponentLastPlayedCard ? 16 : 0,
                      ),
                      child: allOponentPlayedCards.contains(card.id) &&
                              state.isCardTurnComplete(card)
                          ? Stack(
                              children: [
                                GameCard(
                                  key: Key('oponent_revealed_card_${card.id}'),
                                  card: card,
                                  width: oponentCardWidth,
                                  height: oponentCardHeight,
                                ),
                                if (state.isWiningCard(card))
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
                              key: Key('oponent_hidden_card_${card.id}'),
                              width: oponentCardWidth,
                              height: oponentCardHeight,
                            ),
                    ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final card in playerDeck.cards)
                    InkWell(
                      onTap: allPlayerPlayedCards.contains(card.id)
                          ? null
                          : () {
                              context
                                  .read<GameBloc>()
                                  .add(PlayerPlayed(card.id));
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
                              if (state.isWiningCard(card))
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
