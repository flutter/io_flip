import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageSettingsPersistence', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

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
