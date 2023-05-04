import 'package:api_client/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:io_flip/scripts/scripts.dart';

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
        final scriptsResource = context.read<ScriptsResource>();
        final gameScriptMachine = context.read<GameScriptMachine>();

        return ScriptsCubit(
          scriptsResource: scriptsResource,
          gameScriptMachine: gameScriptMachine,
        );
      },
      child: const ScriptsView(),
    );
  }
}
