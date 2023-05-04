import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

void main() {
  group('GameCardRect', () {
    test('rect returns the correct value', () {
      const gameCardSize = GameCardSize.xs();
      const offset = Offset(20, 50);
      const gameCardRect = GameCardRect(
        gameCardSize: gameCardSize,
        offset: offset,
      );

      expect(gameCardRect.rect, offset & gameCardSize.size);
    });
  });

  group('GameCardRectTween', () {
    const begin = GameCardRect(
      gameCardSize: GameCardSize.xs(),
      offset: Offset(20, 50),
    );
    const end = GameCardRect(
      gameCardSize: GameCardSize.lg(),
      offset: Offset(100, 200),
    );
    final tween = GameCardRectTween(begin: begin, end: end);

    group('lerp', () {
      test('with t = 0', () {
        final result = tween.lerp(0);

        expect(result, begin);
      });

      test('with t = 1', () {
        final result = tween.lerp(1);

        expect(result, end);
      });

      for (var i = 1; i < 10; i += 1) {
        final t = i / 10;

        test('with t = $t', () {
          final result = tween.lerp(t)!;

          expect(
            result.offset,
            equals(Offset.lerp(begin.offset, end.offset, t)),
          );
          expect(
            result.gameCardSize,
            equals(GameCardSize.lerp(begin.gameCardSize, end.gameCardSize, t)),
          );
        });
      }
    });
  });
}
