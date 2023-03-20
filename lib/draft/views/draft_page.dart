import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/draft/draft.dart';

class DraftPage extends StatelessWidget {
  const DraftPage({super.key});

  factory DraftPage.routeBuilder(_, __) {
    return const DraftPage(key: Key('draft'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gameResource = context.read<GameResource>();
        return DraftBloc(
          gameResource: gameResource,
        )..add(const DeckRequested());
      },
      child: const DraftView(),
    );
  }
}
