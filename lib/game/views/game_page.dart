import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/game/game.dart';
import 'package:web_socket_client/web_socket_client.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required this.matchId,
    required this.isHost,
    required this.matchConnection,
    super.key,
  });

  factory GamePage.routeBuilder(_, GoRouterState state) {
    final data = state.extra as GamePageData?;

    return GamePage(
      key: const Key('game'),
      matchId: data?.matchId ?? '',
      isHost: data?.isHost ?? false,
      matchConnection: data?.matchConnection,
    );
  }

  final String matchId;
  final bool isHost;
  final WebSocket? matchConnection;

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

class GamePageData {
  const GamePageData({
    required this.isHost,
    required this.matchId,
    required this.matchConnection,
  });

  final bool isHost;
  final String? matchId;
  final WebSocket? matchConnection;
}
