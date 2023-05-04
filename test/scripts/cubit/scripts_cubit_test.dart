// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:io_flip/scripts/cubit/scripts_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockScriptsResource extends Mock implements ScriptsResource {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

void main() {
  group('ScriptsCubit', () {
    late ScriptsResource scriptsResource;
    late GameScriptMachine gameScriptMachine;

    setUp(() {
      scriptsResource = _MockScriptsResource();
      gameScriptMachine = _MockGameScriptMachine();
      when(() => gameScriptMachine.currentScript).thenReturn('script');
    });

    test('has the correct initial value', () {
      expect(
        ScriptsCubit(
          scriptsResource: scriptsResource,
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
        scriptsResource: scriptsResource,
        gameScriptMachine: gameScriptMachine,
      ),
      setUp: () {
        when(() => scriptsResource.updateScript('current', 'script 2'))
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
        verify(() => scriptsResource.updateScript('current', 'script 2'))
            .called(1);
        verify(() => gameScriptMachine.currentScript = 'script 2').called(1);
      },
    );

    blocTest<ScriptsCubit, ScriptsState>(
      'emits failure when an error happens',
      build: () => ScriptsCubit(
        scriptsResource: scriptsResource,
        gameScriptMachine: gameScriptMachine,
      ),
      setUp: () {
        when(() => scriptsResource.updateScript('current', 'script 2'))
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
