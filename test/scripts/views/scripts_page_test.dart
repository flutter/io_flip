// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/scripts/scripts.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

void main() {
  group('ScriptsPage', () {
    late GoRouterState goRouterState;

    setUp(() {
      goRouterState = _MockGoRouterState();
    });

    test('routeBuilder returns a ScriptsPage', () {
      expect(
        ScriptsPage.routeBuilder(null, goRouterState),
        isA<ScriptsPage>(),
      );
    });

    testWidgets('renders a ScriptsView', (tester) async {
      final gameScriptMachine = _MockGameScriptMachine();
      when(() => gameScriptMachine.currentScript).thenReturn('');
      await tester.pumpApp(
        ScriptsPage(),
        gameScriptMachine: gameScriptMachine,
      );

      expect(
        find.byType(ScriptsView),
        findsOneWidget,
      );
    });
  });
}
