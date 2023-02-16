import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/settings/persistence/persistence.dart';
import 'package:top_dash/settings/settings.dart';

class _MockSettingsPersistence extends Mock implements SettingsPersistence {}

void main() {
  group('SettingsController', () {
    late SettingsPersistence persistence;
    late SettingsController controller;

    setUp(() {
      persistence = _MockSettingsPersistence();
      when(persistence.getMusicOn).thenAnswer((_) async => true);
      when(persistence.getSoundsOn).thenAnswer((_) async => true);
      when(() => persistence.getMuted(defaultValue: any(named: 'defaultValue')))
          .thenAnswer((_) async => false);

      when(() => persistence.saveMuted(active: any(named: 'active')))
          .thenAnswer((_) async {});
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
      expect(controller.muted.value, isFalse);
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

    test('can toggle muted', () async {
      await controller.loadStateFromPersistence();
      controller.toggleMuted();

      verify(() => persistence.saveMuted(active: true)).called(1);
    });
  });
}
