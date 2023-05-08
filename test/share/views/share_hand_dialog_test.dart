import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/share/views/views.dart';
import 'package:io_flip/share/widgets/widgets.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockShareResource extends Mock implements ShareResource {}

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
  late ShareResource shareResource;
  setUp(() {
    shareResource = _MockShareResource();
    when(() => shareResource.facebookShareHandUrl(any())).thenReturn('');
    when(() => shareResource.twitterShareHandUrl(any())).thenReturn('');
  });
  group('ShareHandDialog', () {
    testWidgets('renders', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.byType(ShareDialog), findsOneWidget);
    });

    testWidgets('renders a CardShareDialog widget', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.byType(ShareDialog), findsOneWidget);
    });

    testWidgets('renders a CardFan widget', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.byType(CardFan), findsOneWidget);
    });

    testWidgets('renders the users wins and initials', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.text('5 ${tester.l10n.winStreakLabel}'), findsOneWidget);
      expect(find.text('AAA'), findsOneWidget);
    });

    testWidgets('renders the description', (tester) async {
      await tester.pumpSubject(shareResource);
      expect(find.text(tester.l10n.shareTeamDialogDescription), findsOneWidget);
    });

    testWidgets('gets the twitter and facebook share links', (tester) async {
      await tester.pumpSubject(shareResource);

      verify(() => shareResource.twitterShareHandUrl('test')).called(1);
      verify(() => shareResource.facebookShareHandUrl('test')).called(1);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject(ShareResource shareResource) async {
    await mockNetworkImages(() {
      return pumpApp(
        const IoFlipDialog(
          child: ShareHandDialog(
            deck: Deck(id: 'test', userId: '', cards: [card, card, card]),
            wins: 5,
            initials: 'AAA',
          ),
        ),
        shareResource: shareResource,
      );
    });
  }
}
