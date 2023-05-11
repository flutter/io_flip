import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/settings/persistence/persistence.dart';

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
