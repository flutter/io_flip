import 'dart:async';

import 'package:flame/cache.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AssetManager {

  AssetManager(this.images);

  final Images images;
  final _completer = Completer<void>();

  Future<void> get ready => _completer.future;

  Future<void> preload() async {

    final elemenalAnimations = [
      platformAwareAsset(
        desktop: AirDamage.large(size: const GameCardSize.lg()),
        mobile: AirDamage.small(size: const GameCardSize.lg()),
      ),
      platformAwareAsset(
        desktop: WaterDamage.large(size: const GameCardSize.lg()),
        mobile: WaterDamage.small(size: const GameCardSize.lg()),
      ),
      platformAwareAsset(
        desktop: FireDamage.large(size: const GameCardSize.lg()),
        mobile: FireDamage.small(size: const GameCardSize.lg()),
      ),
      platformAwareAsset(
        desktop: EarthDamage.large(size: const GameCardSize.lg()),
        mobile: EarthDamage.small(size: const GameCardSize.lg()),
      ),
      platformAwareAsset(
        desktop: MetalDamage.large(size: const GameCardSize.lg()),
        mobile: MetalDamage.small(size: const GameCardSize.lg()),
      ),
    ];


    for (final animation in elemenalAnimations) {
      await images.load(animation.chargeBackPath);
      await images.load(animation.chargeFrontPath);
      await images.load(animation.damageReceivePath);
      await images.load(animation.damageSendPath);
      await images.load(animation.victoryChargeBackPath);
      await images.load(animation.victoryChargeFrontPath);
    }

    _completer.complete();
  }
}
