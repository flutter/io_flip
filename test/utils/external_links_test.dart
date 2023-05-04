import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('openLink', () {
    late UrlLauncherPlatform urlLauncher;

    setUp(() {
      urlLauncher = _MockUrlLauncher();
      UrlLauncherPlatform.instance = urlLauncher;
    });

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    group('openLink', () {
      test('launches the link', () async {
        when(
          () => urlLauncher.canLaunch(any()),
        ).thenAnswer((_) async => true);

        when(
          () => urlLauncher.launchUrl(any(), any()),
        ).thenAnswer((_) async => true);

        await openLink('uri');

        verify(
          () => urlLauncher.launchUrl(any(), any()),
        ).called(1);
      });

      test('executes the onError callback when it cannot launch', () async {
        var wasCalled = false;

        when(
          () => urlLauncher.canLaunch(any()),
        ).thenAnswer((_) async => false);

        when(
          () => urlLauncher.launchUrl(any(), any()),
        ).thenAnswer((_) async => true);

        await openLink(
          'url',
          onError: () {
            wasCalled = true;
          },
        );

        await expectLater(wasCalled, isTrue);
      });
    });
  });
}
