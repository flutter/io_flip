import 'package:api_client/api_client.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/match_making/match_making.dart';

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
      createPrivateMatch: state.queryParams['createPrivateMatch'] == 'true',
      inviteCode: state.queryParams['inviteCode'],
      deck: data?.cards ?? [],
    );
  }

  final bool createPrivateMatch;
  final String? inviteCode;
  final List<Card> deck;

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
        final connectionRepository = context.read<ConnectionRepository>();
        final gameResource = context.read<GameResource>();
        return MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          cardIds: deck.map((card) => card.id).toList(),
        )..add(mapEvent());
      },
      child: MatchMakingView(deck: deck),
    );
  }
}

class MatchMakingPageData extends Equatable {
  const MatchMakingPageData({required this.cards});
  final List<Card> cards;

  @override
  List<Object?> get props => [cards];
}
