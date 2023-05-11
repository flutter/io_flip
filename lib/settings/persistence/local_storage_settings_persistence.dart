// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? defaultValue;
  }

  @override
  Future<bool> getMusicOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('musicOn') ?? defaultValue;
  }

  @override
  Future<void> saveSoundsOn({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('soundsOn', active);
  }

  @override
  Future<void> saveMusicOn({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('musicOn', active);
  }
}
