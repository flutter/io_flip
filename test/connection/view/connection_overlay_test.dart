import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/connection/connection.dart';

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

      testWidgets('shows unknown error code', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text(tester.l10n.unknownConnectionError), findsOneWidget);
      });

      testWidgets('shows player already connected error code', (tester) async {
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
      });
    });
  });
}
