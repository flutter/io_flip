import 'package:api_client/api_client.dart';
import 'package:config_repository/config_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

class MatchMakingPage extends StatelessWidget {
  const MatchMakingPage({
    required this.createPrivateMatch,
    required this.inviteCode,
    required this.deck,
    super.key,
  });

  factory MatchMakingPage.routeBuilder(_, GoRouterState state) {
    final data = state.extra as MatchMakingPageData?;

    return MatchMakingPage(
      key: const Key('match_making'),
      createPrivateMatch: data?.createPrivateMatch ?? false,
      inviteCode: data?.inviteCode,
      deck: data!.deck,
    );
  }

  final bool createPrivateMatch;
  final String? inviteCode;
  final Deck deck;

  MatchMakingEvent mapEvent() {
    return inviteCode != null
        ? GuestPrivateMatchRequested(inviteCode!)
        : createPrivateMatch
            ? const PrivateMatchRequested()
            : const MatchRequested();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final matchMakerRepository = context.read<MatchMakerRepository>();
        final configRepository = context.read<ConfigRepository>();
        final connectionRepository = context.read<ConnectionRepository>();
        final gameResource = context.read<GameResource>();
        return MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          connectionRepository: connectionRepository,
          configRepository: configRepository,
          gameResource: gameResource,
          deckId: deck.id,
        )..add(mapEvent());
      },
      child: MatchMakingView(
        deck: deck,
        tryAgainEvent: mapEvent(),
      ),
    );
  }
}

class MatchMakingPageData extends Equatable {
  const MatchMakingPageData({
    required this.deck,
    this.createPrivateMatch,
    this.inviteCode,
  });

  final Deck deck;
  final bool? createPrivateMatch;
  final String? inviteCode;

  @override
  List<Object?> get props => [deck, createPrivateMatch, inviteCode];
}
