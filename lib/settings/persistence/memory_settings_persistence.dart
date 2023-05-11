// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:io_flip/settings/persistence/persistence.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.
class MemoryOnlySettingsPersistence implements SettingsPersistence {
  bool soundsOn = false;
  bool musicOn = false;

  String playerName = 'Player';

  @override
  Future<bool> getSoundsOn({bool defaultValue = false}) async => soundsOn;

  @override
  Future<bool> getMusicOn({bool defaultValue = false}) async => musicOn;

  @override
  Future<void> saveSoundsOn({required bool active}) async => soundsOn = active;

  @override
  Future<void> saveMusicOn({required bool active}) async => musicOn = active;
}
