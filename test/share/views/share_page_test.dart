import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SharePage', () {
    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    group('routeBuilder', () {
      test('returns SharePage', () {
        final result = SharePage.routeBuilder(0, 0);
        expect(result, isA<SharePage>());
      });
    });

    testWidgets('contains title', (tester) async {
      await tester.pumpApp(const SharePage());

      expect(find.text('Share your hand!'), findsOneWidget);
    });

    testWidgets('contains share button', (tester) async {
      await tester.pumpApp(const SharePage());

      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('opens native share dialog on ios', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      var nativeShareCalled = false;
      Future<void> mockNativeShare(String url, {String? subject}) async {
        expect(url, SharePage.shareUrl);
        expect(subject, SharePage.shareText);
        nativeShareCalled = true;
      }

      await tester.pumpApp(SharePage(nativeShare: mockNativeShare));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Share'));

      expect(nativeShareCalled, isTrue);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('opens native share dialog on android', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      var nativeShareCalled = false;
      Future<void> mockNativeShare(String url, {String? subject}) async {
        expect(url, SharePage.shareUrl);
        expect(subject, SharePage.shareText);
        nativeShareCalled = true;
      }

      await tester.pumpApp(SharePage(nativeShare: mockNativeShare));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Share'));

      expect(nativeShareCalled, isTrue);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('opens our share dialog on macOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      await tester.pumpApp(const SharePage());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Share'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareDialog), findsOneWidget);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('contains main menu button', (tester) async {
      await tester.pumpApp(const SharePage());

      expect(find.text('Main Menu'), findsOneWidget);
    });

    testWidgets('navigates to main menu on main menu button tap',
        (tester) async {
      final goRouter = MockGoRouter();
      await tester.pumpApp(const SharePage(), router: goRouter);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Main Menu'));

      verify(() => goRouter.go('/')).called(1);
    });
  });
}
