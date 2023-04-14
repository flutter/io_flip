// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';

import '../../helpers/helpers.dart';

class _MockHowToPlayBloc extends MockBloc<HowToPlayEvent, HowToPlayState>
    implements HowToPlayBloc {}

void main() {
  group('HowToPlayView', () {
    late HowToPlayBloc bloc;

    setUp(() {
      bloc = _MockHowToPlayBloc();
    });

    void mockStates(List<HowToPlayState> states) {
      whenListen(
        bloc,
        Stream.fromIterable(states),
        initialState: states.isNotEmpty ? states.first : null,
      );
    }

    group('renders', () {
      testWidgets('step view', (tester) async {
        mockStates([HowToPlayState()]);
        await tester.pumpSubject(bloc);
        expect(find.byType(HowToPlayStepView), findsOneWidget);
      });

      testWidgets('close button', (tester) async {
        mockStates([HowToPlayState()]);
        await tester.pumpSubject(bloc);
        expect(find.byType(CloseButton), findsOneWidget);
      });

      testWidgets('page indicator', (tester) async {
        mockStates([HowToPlayState()]);
        await tester.pumpSubject(bloc);
        expect(find.byKey(Key('how_to_play_page_indicator')), findsOneWidget);
      });

      testWidgets('navigation buttons', (tester) async {
        mockStates([HowToPlayState()]);
        await tester.pumpSubject(bloc);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('first step when initially showing', (tester) async {
        mockStates([HowToPlayState()]);
        await tester.pumpSubject(bloc);
        expect(find.byType(HowToPlayIntro), findsOneWidget);
      });
    });

    testWidgets('close button closes dialog', (tester) async {
      final goRouter = MockGoRouter();
      when(goRouter.canPop).thenReturn(true);
      mockStates([HowToPlayState()]);

      await tester.pumpSubject(
        bloc,
        goRouter: goRouter,
      );

      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();

      verify(goRouter.pop).called(1);
    });

    testWidgets('can navigate the entire tutorial', (tester) async {
      final goRouter = MockGoRouter();
      when(goRouter.canPop).thenReturn(true);
      await tester.pumpSubject(
        HowToPlayBloc(),
        goRouter: goRouter,
      );

      expect(find.byType(HowToPlayIntro), findsOneWidget);

      final nextButton = find.byIcon(Icons.arrow_forward);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlayHandBuilding), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlaySuitsIntro), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(SuitsWheel), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(SuitsWheel), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(SuitsWheel), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(SuitsWheel), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(SuitsWheel), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlaySummary), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      verify(goRouter.pop).called(1);
    });

    testWidgets('can navigate back', (tester) async {
      final goRouter = MockGoRouter();
      when(goRouter.canPop).thenReturn(true);
      await tester.pumpSubject(
        HowToPlayBloc(),
        goRouter: goRouter,
      );

      final nextButton = find.byIcon(Icons.arrow_forward);
      final backButton = find.byIcon(Icons.arrow_back);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlayIntro), findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      verify(goRouter.pop).called(1);
    });
  });
}

extension HowToPlayViewTest on WidgetTester {
  Future<void> pumpSubject(
    HowToPlayBloc bloc, {
    GoRouter? goRouter,
  }) {
    return pumpApp(
      Dialog(
        child: BlocProvider<HowToPlayBloc>.value(
          value: bloc,
          child: HowToPlayView(),
        ),
      ),
      router: goRouter,
    );
  }
}
