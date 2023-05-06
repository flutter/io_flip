import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/game/game.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required this.matchId,
    required this.isHost,
    required this.deck,
    super.key,
  });

  factory GamePage.routeBuilder(_, GoRouterState state) {
    final data = state.extra as GamePageData?;

    return GamePage(
      key: const Key('game'),
      matchId: data?.matchId ?? '',
      isHost: data?.isHost ?? false,
      deck: data?.deck,
    );
  }

  final String matchId;
  final bool isHost;
  final Deck? deck;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gameResource = context.read<GameResource>();
        final matchMakerRepository = context.read<MatchMakerRepository>();
        final connectionRepository = context.read<ConnectionRepository>();
        final audioController = context.read<AudioController>();
        final matchSolver = context.read<MatchSolver>();
        final user = context.read<User>();
        return GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
          connectionRepository: connectionRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: isHost,
        )..add(MatchRequested(matchId, deck));
      },
      child: const GameView(),
    );
  }
}

class GamePageData extends Equatable {
  const GamePageData({
    required this.isHost,
    required this.matchId,
    required this.deck,
  });

  final bool isHost;
  final String? matchId;
  final Deck deck;

  @override
  List<Object?> get props => [isHost, matchId, deck];
}
