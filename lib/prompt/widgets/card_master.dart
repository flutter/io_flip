import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/utils/utils.dart';

class CardMaster extends StatefulWidget {
  const CardMaster({
    super.key,
    this.deviceInfoAwareAsset,
  });

  final DeviceInfoAwareAsset<String>? deviceInfoAwareAsset;

  static const cardMasterHeight = 312.0;

  @override
  State<CardMaster> createState() => _CardMasterState();
}

class _CardMasterState extends State<CardMaster> {
  late final Images images;
  late final bool isStill;
  String? asset;

  @override
  void initState() {
    super.initState();
    images = context.read<Images>();

    _loadAsset();
  }

  Future<void> _loadAsset() async {
    final loaded = await (widget.deviceInfoAwareAsset ?? deviceInfoAwareAsset)(
      predicate: isOlderAndroid,
      asset: () => Assets.images.mobile.cardMasterStill.keyName,
      orElse: () => platformAwareAsset(
        desktop: Assets.images.desktop.cardMaster.keyName,
        mobile: Assets.images.mobile.cardMaster.keyName,
      ),
    );

    setState(() {
      asset = loaded;
      isStill = asset == Assets.images.mobile.cardMasterStill.keyName;
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (asset != null) {
      images.clear(asset!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadedAsset = asset;

    if (loadedAsset == null) {
      return const SizedBox.square(dimension: CardMaster.cardMasterHeight);
    }

    if (isStill) {
      return Image.asset(
        loadedAsset,
        height: CardMaster.cardMasterHeight,
      );
    } else {
      return SizedBox.square(
        dimension: CardMaster.cardMasterHeight,
        child: SpriteAnimationWidget.asset(
          path: loadedAsset,
          images: images,
          data: SpriteAnimationData.sequenced(
            amount: 57,
            amountPerRow: 19,
            textureSize: platformAwareAsset(
              desktop: Vector2(812, 812),
              mobile: Vector2(406, 406),
            ),
            stepTime: 0.04,
          ),
        ),
      );
    }
  }
}
