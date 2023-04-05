import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';

class DraftPage extends StatelessWidget {
  const DraftPage({required this.prompts, super.key});

  factory DraftPage.routeBuilder(_, GoRouterState state) {
    final prompts = state.extra as Prompt?;
    return DraftPage(
      prompts: prompts ?? const Prompt(),
      key: const Key('draft'),
    );
  }

  final Prompt prompts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gameResource = context.read<GameResource>();
        return DraftBloc(
          gameResource: gameResource,
        )..add(DeckRequested(prompts));
      },
      child: const DraftView(),
    );
  }
}
