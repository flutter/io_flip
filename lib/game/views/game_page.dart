import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/game/game.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required this.matchId,
    required this.isHost,
    super.key,
  });

  factory GamePage.routeBuilder(_, GoRouterState state) {
    return GamePage(
      key: const Key('game'),
      matchId: state.params['matchId'] ?? '',
      isHost: (state.params['isHost'] ?? '') == 'true',
    );
  }

  final String matchId;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gameClient = context.read<GameClient>();
        return GameBloc(
          gameClient: gameClient,
          isHost: isHost,
        )..add(MatchRequested(matchId));
      },
      child: const GameView(),
    );
  }
}
