import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_dash/settings/persistence/persistence.dart';

void main() {
  group('LocalStorageSettingsPersistence', () {
    test('getMusicOn', () async {
      SharedPreferences.setMockInitialValues({
        'musicOn': false,
      });

      final persistence = LocalStorageSettingsPersistence();
      final value = await persistence.getMusicOn();
      expect(value, isFalse);
    });

    test('getSoundsOn', () async {
      SharedPreferences.setMockInitialValues({
        'soundsOn': false,
      });

      final persistence = LocalStorageSettingsPersistence();
      final value = await persistence.getSoundsOn();
      expect(value, isFalse);
    });

    test('getMuted', () async {
      SharedPreferences.setMockInitialValues({
        'mute': false,
      });

      final persistence = LocalStorageSettingsPersistence();
      final value = await persistence.getMuted(defaultValue: false);
      expect(value, isFalse);
    });

    test('getMuted returns default value if null', () async {
      final persistence = LocalStorageSettingsPersistence();
      final value = await persistence.getMuted(defaultValue: false);
      expect(value, isFalse);
    });

    test('saveMuted', () async {
      final persistence = LocalStorageSettingsPersistence();

      await persistence.saveMuted(active: true);

      expect(
        await persistence.getMuted(defaultValue: false),
        isTrue,
      );
    });

    test('saveMusicOn', () async {
      final persistence = LocalStorageSettingsPersistence();

      await persistence.saveMusicOn(active: true);

      expect(
        await persistence.getMusicOn(),
        isTrue,
      );
    });

    test('saveSoundsOn', () async {
      final persistence = LocalStorageSettingsPersistence();

      await persistence.saveSoundsOn(active: true);

      expect(
        await persistence.getSoundsOn(),
        isTrue,
      );
    });
  });
}
