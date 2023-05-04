// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/scripts/scripts.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockScriptsCubit extends Mock implements ScriptsCubit {}

void main() {
  group('ScriptsView', () {
    late ScriptsCubit cubit;

    void mockState(ScriptsState state) {
      whenListen(
        cubit,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      cubit = _MockScriptsCubit();
    });

    testWidgets('renders correctly', (tester) async {
      mockState(
        ScriptsState(
          status: ScriptsStateStatus.loaded,
          current: 'script',
        ),
      );
      await tester.pumpSubject(cubit);

      expect(find.byType(ScriptsView), findsOneWidget);
    });

    testWidgets('saves the script', (tester) async {
      when(() => cubit.updateScript(any())).thenAnswer((_) async {});
      mockState(
        ScriptsState(
          status: ScriptsStateStatus.loaded,
          current: 'script',
        ),
      );
      await tester.pumpSubject(cubit);

      await tester.tap(find.byType(Icon));
      await tester.pump();

      verify(() => cubit.updateScript('script')).called(1);
    });

    testWidgets('renders a loading indicator when is saving', (tester) async {
      mockState(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
      );
      await tester.pumpSubject(cubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders an error message', (tester) async {
      final initial = ScriptsState(
        status: ScriptsStateStatus.loaded,
        current: 'script',
      );
      final loading = ScriptsState(
        status: ScriptsStateStatus.loading,
        current: 'script',
      );
      final state = ScriptsState(
        status: ScriptsStateStatus.failed,
        current: 'script',
      );
      whenListen(
        cubit,
        Stream.fromIterable([
          initial,
          loading,
          state,
        ]),
        initialState: initial,
      );
      await tester.pumpSubject(cubit);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

extension ScriptsViewTest on WidgetTester {
  Future<void> pumpSubject(
    ScriptsCubit cubit,
  ) {
    return pumpApp(
      BlocProvider<ScriptsCubit>.value(
        value: cubit,
        child: ScriptsView(),
      ),
    );
  }
}
