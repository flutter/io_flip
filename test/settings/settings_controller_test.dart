import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsPersistence extends Mock implements SettingsPersistence {}

void main() {
  group('SettingsController', () {
    late SettingsPersistence persistence;
    late SettingsController controller;

    setUp(() {
      persistence = _MockSettingsPersistence();
      when(persistence.getMusicOn).thenAnswer((_) async => true);
      when(persistence.getSoundsOn).thenAnswer((_) async => true);

      when(() => persistence.saveMusicOn(active: any(named: 'active')))
          .thenAnswer((_) async {});
      when(() => persistence.saveSoundsOn(active: any(named: 'active')))
          .thenAnswer((_) async {});

      controller = SettingsController(persistence: persistence);
    });

    test('loads the values from persistence', () async {
      await controller.loadStateFromPersistence();

      expect(controller.musicOn.value, isTrue);
      expect(controller.soundsOn.value, isTrue);
    });

    test('can toggle musicOn', () async {
      await controller.loadStateFromPersistence();
      controller.toggleMusicOn();

      verify(() => persistence.saveMusicOn(active: false)).called(1);
    });

    test('can toggle soundsOn', () async {
      await controller.loadStateFromPersistence();
      controller.toggleSoundsOn();

      verify(() => persistence.saveSoundsOn(active: false)).called(1);
    });
  });
}
