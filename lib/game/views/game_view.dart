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
        if (state is MatchLoadingState) {
          return const Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is MatchLoadFailedState) {
          return const Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: Text('Unable to join game!'),
            ),
          );
        }

        if (state is MatchLoadedState) {
          return Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: const _GameBoard(),
          );
        }

        return const Scaffold(backgroundColor: TopDashColors.backgroundMain);
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
        bloc.isHost ? state.match.guestDeck : state.match.hostDeck;

    final oponentDeck =
        bloc.isHost ? state.match.hostDeck : state.match.guestDeck;

    final query = MediaQuery.of(context);

    final cardWidth = query.size.width * .25;
    final cardHeight = cardWidth * 1.4;

    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final _ in oponentDeck.cards)
                    FlippedGameCard(
                      width: cardWidth * .6,
                      height: cardHeight * .6,
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
                      onTap: () {
                        context.read<GameBloc>().add(PlayerPlayed(card.id));
                      },
                      child: GameCard(
                        card: card,
                        width: cardWidth,
                        height: cardHeight,
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
