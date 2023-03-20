import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_script_machine/game_script_machine.dart';

part 'scripts_state.dart';

class ScriptsCubit extends Cubit<ScriptsState> {
  ScriptsCubit({
    required this.scriptsResource,
    required this.gameScriptMachine,
  }) : super(
          ScriptsState(
            status: ScriptsStateStatus.loaded,
            current: gameScriptMachine.currentScript,
          ),
        );

  final ScriptsResource scriptsResource;
  final GameScriptMachine gameScriptMachine;

  Future<void> updateScript(String content) async {
    try {
      emit(
        state.copyWith(status: ScriptsStateStatus.loading),
      );

      await scriptsResource.updateScript('current', content);
      gameScriptMachine.currentScript = content;

      emit(
        state.copyWith(
          status: ScriptsStateStatus.loaded,
          current: content,
        ),
      );
    } catch (e, s) {
      emit(
        state.copyWith(
          status: ScriptsStateStatus.failed,
        ),
      );
      addError(e, s);
    }
  }
}
