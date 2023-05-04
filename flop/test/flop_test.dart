// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flop/flop/flop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlopBloc extends Mock implements FlopBloc {}

void main() {
  group('Flop', () {
    testWidgets('renders FlopView', (tester) async {
      final bloc = _MockFlopBloc();
      whenListen(
        bloc,
        Stream.fromIterable([
          const FlopState.initial(),
        ]),
        initialState: const FlopState.initial(),
      );
      await tester.pumpWidget(
        BlocProvider<FlopBloc>.value(
          value: bloc,
          child: MaterialApp(
            home: Scaffold(
              body: FlopView(),
            ),
          ),
        ),
      );
      expect(find.byType(FlopView), findsOneWidget);
    });
  });
}
