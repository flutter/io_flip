import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/connection/connection.dart';
import 'package:io_flip_ui/top_dash_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

void main() {
  group('ConnectionOverlay', () {
    const child = SizedBox(key: Key('child'));
    late ConnectionBloc connectionBloc;

    setUp(() {
      connectionBloc = _MockConnectionBloc();
    });

    Widget buildSubject() => BlocProvider.value(
          value: connectionBloc,
          child: const ConnectionOverlay(child: child),
        );

    group('when state is not ConnectionFailure', () {
      setUp(() {
        when(() => connectionBloc.state).thenReturn(const ConnectionSuccess());
      });
      testWidgets('shows child', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byWidget(child), findsOneWidget);
      });
    });

    group('when state is  ConnectionFailure', () {
      setUp(() {
        when(() => connectionBloc.state).thenReturn(
          const ConnectionFailure(
            WebSocketErrorCode.unknown,
          ),
        );
      });

      testWidgets('shows child', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byWidget(child), findsOneWidget);
      });

      testWidgets('shows unknown error messages', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text(tester.l10n.unknownConnectionError), findsOneWidget);
        expect(
          find.text(tester.l10n.unknownConnectionErrorBody),
          findsOneWidget,
        );
      });

      testWidgets('shows retry button for unknown error', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(
            RoundedButton,
            tester.l10n.unknownConnectionErrorButton,
          ),
          findsOneWidget,
        );
      });

      testWidgets('tapping retry button adds event to bloc', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(
          find.widgetWithText(
            RoundedButton,
            tester.l10n.unknownConnectionErrorButton,
          ),
        );

        verify(() => connectionBloc.add(const ConnectionRequested())).called(1);
      });

      testWidgets(
        'shows player already connected error messages',
        (tester) async {
          when(() => connectionBloc.state).thenReturn(
            const ConnectionFailure(
              WebSocketErrorCode.playerAlreadyConnected,
            ),
          );

          await tester.pumpApp(buildSubject());

          expect(
            find.text(tester.l10n.playerAlreadyConnectedError),
            findsOneWidget,
          );
          expect(
            find.text(tester.l10n.playerAlreadyConnectedErrorBody),
            findsOneWidget,
          );
        },
      );
    });
  });
}
