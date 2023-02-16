import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/settings/persistence/persistence.dart';

void main() {
  group('MemoryOnlySettingsPersistence', () {
    test('getMusicOn', () async {
      final persistence = MemoryOnlySettingsPersistence()..musicOn = false;

      final value = await persistence.getMusicOn();
      expect(value, isFalse);
    });

    test('getSoundsOn', () async {
      final persistence = MemoryOnlySettingsPersistence()..soundsOn = false;
      final value = await persistence.getSoundsOn();
      expect(value, isFalse);
    });

    test('getMuted', () async {
      final persistence = MemoryOnlySettingsPersistence()..muted = false;
      final value = await persistence.getMuted(defaultValue: false);
      expect(value, isFalse);
    });

    test('getMuted returns default value if null', () async {
      final persistence = MemoryOnlySettingsPersistence();
      final value = await persistence.getMuted(defaultValue: false);
      expect(value, isFalse);
    });

    test('saveMuted', () async {
      final persistence = MemoryOnlySettingsPersistence();

      await persistence.saveMuted(active: true);

      expect(
        await persistence.getMuted(defaultValue: false),
        isTrue,
      );
    });

    test('saveMusicOn', () async {
      final persistence = MemoryOnlySettingsPersistence();

      await persistence.saveMusicOn(active: true);

      expect(
        await persistence.getMusicOn(),
        isTrue,
      );
    });

    test('saveSoundsOn', () async {
      final persistence = MemoryOnlySettingsPersistence();

      await persistence.saveSoundsOn(active: true);

      expect(
        await persistence.getSoundsOn(),
        isTrue,
      );
    });
  });
}
