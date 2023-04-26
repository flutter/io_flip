import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/router/router.dart';

void main() {
  group('createRouter', () {
    test('adds the script page when isScriptsEnabled is true', () {
      try {
        createRouter(isScriptsEnabled: true).goNamed(
          '_super_secret_scripts_page',
        );
      } catch (_) {
        fail('Should not throw an exception');
      }
    });

    test("doesn't adds the scripts page when isScriptsEnabled is false", () {
      expect(
        () => createRouter(isScriptsEnabled: false)
            .goNamed('_super_secret_scripts_page'),
        throwsAssertionError,
      );
    });
  });
}
