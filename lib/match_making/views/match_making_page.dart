import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/match_making/match_making.dart';

class MatchMakingPage extends StatelessWidget {
  const MatchMakingPage({
    required this.playerCardIds,
    required this.createPrivateMatch,
    required this.inviteCode,
    super.key,
  });

  factory MatchMakingPage.routeBuilder(_, GoRouterState state) {
    return MatchMakingPage(
      key: const Key('match_making'),
      playerCardIds: state.queryParametersAll['cardId'] ?? [],
      createPrivateMatch: state.queryParams['createPrivateMatch'] == 'true',
      inviteCode: state.queryParams['inviteCode'],
    );
  }

  final List<String> playerCardIds;
  final bool createPrivateMatch;
  final String? inviteCode;

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
        final gameClient = context.read<GameClient>();
        return MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          gameClient: gameClient,
          cardIds: playerCardIds,
        )..add(mapEvent());
      },
      child: const MatchMakingView(),
    );
  }
}
