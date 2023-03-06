import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/game/game.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required this.matchId,
    super.key,
  });

  factory GamePage.routeBuilder(_, GoRouterState state) {
    return GamePage(
      key: const Key('game'),
      matchId: state.params['matchId'] ?? '',
    );
  }

  final String matchId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gameClient = context.read<GameClient>();
        return GameBloc(
          gameClient: gameClient,
        )..add(MatchRequested(matchId));
      },
      child: const GameView(),
    );
  }
}
