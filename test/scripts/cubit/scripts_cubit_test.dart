// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/scripts/cubit/scripts_cubit.dart';

class _MockGameClient extends Mock implements GameClient {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

void main() {
  group('ScriptsCubit', () {
    late GameClient gameClient;
    late GameScriptMachine gameScriptMachine;

    setUp(() {
      gameClient = _MockGameClient();
      gameScriptMachine = _MockGameScriptMachine();
      when(() => gameScriptMachine.currentScript).thenReturn('script');
    });

    test('has the correct initial value', () {
      expect(
        ScriptsCubit(
          gameClient: gameClient,
          gameScriptMachine: gameScriptMachine,
        ).state,
        equals(
          ScriptsState(
            status: ScriptsStateStatus.loaded,
            current: 'script',
          ),
        ),
      );
    });

    blocTest<ScriptsCubit, ScriptsState>(
      'updates the script',
      build: () => ScriptsCubit(
        gameClient: gameClient,
        gameScriptMachine: gameScriptMachine,
      ),
      setUp: () {
        when(() => gameClient.updateScript('current', 'script 2'))
            .thenAnswer((_) async {});
      },
      act: (cubit) {
        cubit.updateScript('script 2');
      },
      expect: () => [
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
        ScriptsState(
          status: ScriptsStateStatus.loaded,
          current: 'script 2',
        ),
      ],
      verify: (_) {
        verify(() => gameClient.updateScript('current', 'script 2')).called(1);
        verify(() => gameScriptMachine.currentScript = 'script 2').called(1);
      },
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'emits failure when an error happens',
      build: () => ScriptsCubit(
        gameClient: gameClient,
        gameScriptMachine: gameScriptMachine,
      ),
      setUp: () {
        when(() => gameClient.updateScript('current', 'script 2'))
            .thenThrow(Exception('Ops'));
      },
      act: (cubit) {
        cubit.updateScript('script 2');
      },
      expect: () => [
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
        ScriptsState(
          status: ScriptsStateStatus.failed,
          current: 'script',
        ),
      ],
    );
  });
}
