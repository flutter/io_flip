import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:top_dash/scripts/scripts.dart';

class ScriptsPage extends StatelessWidget {
  const ScriptsPage({super.key});

  factory ScriptsPage.routeBuilder(_, __) {
    return const ScriptsPage(
      key: Key('scripts_page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScriptsCubit>(
      create: (context) {
        final gameClient = context.read<GameClient>();
        final gameScriptMachine = context.read<GameScriptMachine>();

        return ScriptsCubit(
          gameClient: gameClient,
          gameScriptMachine: gameScriptMachine,
        );
      },
      child: const ScriptsView(),
    );
  }
}
