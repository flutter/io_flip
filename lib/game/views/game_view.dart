import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Host:'),
                  for (final card in state.match.hostDeck.cards)
                    Text(card.name),
                  const SizedBox(height: TopDashSpacing.lg),
                  const Text('Guest'),
                  for (final card in state.match.guestDeck.cards)
                    Text(card.name),
                ],
              ),
            ),
          );
        }

        return const Scaffold(backgroundColor: TopDashColors.backgroundMain);
      },
    );
  }
}
