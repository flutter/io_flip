import 'package:api_client/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockShareResource extends Mock implements ShareResource {}

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
  late ShareResource shareResource;
  setUp(() {
    shareResource = _MockShareResource();
    when(() => shareResource.facebookShareCardUrl(any())).thenReturn('');
    when(() => shareResource.twitterShareCardUrl(any())).thenReturn('');
  });
  group('ShareCardDialog', () {
    testWidgets('renders', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.byType(ShareDialog), findsOneWidget);
    });

    testWidgets('renders a CardShareDialog widget', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.byType(ShareDialog), findsOneWidget);
    });

    testWidgets('renders a GameCard widget', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.byType(GameCard), findsOneWidget);
    });

    testWidgets('renders the description', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.text(tester.l10n.shareCardDialogDescription), findsOneWidget);
    });

    testWidgets('gets the twitter and facebook share links', (tester) async {
      await tester.pumpSubject(shareResource);

      verify(() => shareResource.twitterShareCardUrl('')).called(1);
      verify(() => shareResource.facebookShareCardUrl('')).called(1);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject(ShareResource shareResource) async {
    await mockNetworkImages(() {
      when(() => shareResource.twitterShareCardUrl(any())).thenReturn('');
      when(() => shareResource.facebookShareCardUrl(any())).thenReturn('');
      return pumpApp(
        const SingleChildScrollView(
          child: ShareCardDialog(
            card: card,
          ),
        ),
        shareResource: shareResource,
      );
    });
  }
}
