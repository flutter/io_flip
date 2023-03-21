import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/game/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required this.matchId,
    required this.isHost,
    required this.matchConnection,
    super.key,
  });

  factory GamePage.routeBuilder(_, GoRouterState state) {
    final matchConnection =
        state.extra as WebSocketChannel?; // -> casting is important
    // return GoToScreen(object: sample);

    return GamePage(
      key: const Key('game'),
      matchId: state.params['matchId'] ?? '',
      isHost: state.params['isHost'] == 'true',
      matchConnection: matchConnection,
    );
  }

  final String matchId;
  final bool isHost;
  final WebSocketChannel? matchConnection;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gameResource = context.read<GameResource>();
        final matchMakerRepository = context.read<MatchMakerRepository>();
        final matchSolver = context.read<MatchSolver>();
        final user = context.read<User>();
        return GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: isHost,
          matchConnection: matchConnection,
        )..add(MatchRequested(matchId));
      },
      child: const GameView(),
    );
  }
}
