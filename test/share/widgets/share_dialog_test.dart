import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/share/bloc/download_bloc.dart';
import 'package:io_flip/share/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockDownloadBloc extends MockBloc<DownloadEvent, DownloadState>
    implements DownloadBloc {}

String? launchedUrl;
const shareUrl = 'https://example.com';
const card = Card(
  id: '',
  name: 'name',
  description: 'description',
  image: '',
  rarity: false,
  power: 1,
  suit: Suit.air,
);

void main() {
  group('ShareDialog', () {
    late DownloadBloc downloadBloc;

    setUp(() {
      downloadBloc = _MockDownloadBloc();
      when(() => downloadBloc.state).thenReturn(
        const DownloadState(),
      );
    });

    setUpAll(() {
      launchedUrl = null;
    });

    testWidgets('renders the content', (tester) async {
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
        content: const Text('test'),
      );

      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('renders a Twitter button', (tester) async {
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );

      expect(find.text(tester.l10n.twitterButtonLabel), findsOneWidget);
    });

    testWidgets(
      'tapping the Twitter button launches the correct url',
      (tester) async {
        await tester.pumpSubject(
          downloadBloc: downloadBloc,
        );

        await tester.tap(find.text(tester.l10n.twitterButtonLabel));

        expect(
          launchedUrl,
          shareUrl,
        );
      },
    );

    testWidgets('renders a Facebook button', (tester) async {
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );
      expect(find.text(tester.l10n.facebookButtonLabel), findsOneWidget);
    });

    testWidgets(
      'tapping the Facebook button launches the correct url',
      (tester) async {
        await tester.pumpSubject(
          downloadBloc: downloadBloc,
        );

        await tester.tap(find.text(tester.l10n.facebookButtonLabel));

        expect(
          launchedUrl,
          equals(
            shareUrl,
          ),
        );
      },
    );

    testWidgets('renders a save button', (tester) async {
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );
      expect(find.text(tester.l10n.saveButtonLabel), findsOneWidget);
    });

    testWidgets('calls save on save button tap', (tester) async {
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.text(tester.l10n.saveButtonLabel));
      verify(
        () => downloadBloc.add(const DownloadCardsRequested(cards: [card])),
      ).called(1);
    });

    testWidgets('renders a downloading button while the downloading',
        (tester) async {
      when(() => downloadBloc.state)
          .thenReturn(const DownloadState(status: DownloadStatus.loading));
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );
      expect(find.text(tester.l10n.downloadingButtonLabel), findsOneWidget);
    });

    testWidgets('renders a success message while on download complete',
        (tester) async {
      when(() => downloadBloc.state)
          .thenReturn(const DownloadState(status: DownloadStatus.completed));
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );
      expect(find.text(tester.l10n.downloadCompleteLabel), findsOneWidget);
    });

    testWidgets('renders a fail message while on download failure',
        (tester) async {
      when(() => downloadBloc.state)
          .thenReturn(const DownloadState(status: DownloadStatus.failure));
      await tester.pumpSubject(
        downloadBloc: downloadBloc,
      );
      expect(find.text(tester.l10n.downloadFailedLabel), findsOneWidget);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject({
    required DownloadBloc downloadBloc,
    Widget? content,
  }) async {
    await mockNetworkImages(() {
      return pumpApp(
        BlocProvider<DownloadBloc>.value(
          value: downloadBloc,
          child: ShareDialogView(
            content: content ?? Container(),
            twitterShareUrl: shareUrl,
            facebookShareUrl: shareUrl,
            urlLauncher: (url) async {
              launchedUrl = url;
            },
            downloadCards: const [card],
          ),
        ),
      );
    });
  }
}
