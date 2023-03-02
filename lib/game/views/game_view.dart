import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/style/palette.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is MatchLoadingState) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is MatchLoadFailedState) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: const Center(
              child: Text('Unable to join game!'),
            ),
          );
        }

        if (state is MatchLoadedState) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Host:'),
                  for (final card in state.match.hostDeck.cards)
                    Text(card.name),
                  const SizedBox(height: 16),
                  const Text('Guest'),
                  for (final card in state.match.guestDeck.cards)
                    Text(card.name),
                ],
              ),
            ),
          );
        }

        return Scaffold(backgroundColor: palette.backgroundMain);
      },
    );
  }
}
