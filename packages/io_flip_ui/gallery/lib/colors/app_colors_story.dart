import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AppColorsStory extends StatelessWidget {
  const AppColorsStory({super.key});

  @override
  Widget build(BuildContext context) {
    const colorItems = [
      _ColorItem(name: 'gold', color: IoFlipColors.seedGold),
      _ColorItem(name: 'silver', color: IoFlipColors.seedSilver),
      _ColorItem(name: 'bronze', color: IoFlipColors.seedBronze),
      _ColorItem(name: 'seedLightBlue', color: IoFlipColors.seedLightBlue),
      _ColorItem(name: 'seedBlue', color: IoFlipColors.seedBlue),
      _ColorItem(name: 'seedRed', color: IoFlipColors.seedRed),
      _ColorItem(name: 'seedYellow', color: IoFlipColors.seedYellow),
      _ColorItem(name: 'seedGreen', color: IoFlipColors.seedGreen),
      _ColorItem(name: 'seedBrown', color: IoFlipColors.seedBrown),
      _ColorItem(name: 'seedBlack', color: IoFlipColors.seedBlack),
      _ColorItem(name: 'seedGrey30', color: IoFlipColors.seedGrey30),
      _ColorItem(name: 'seedGrey50', color: IoFlipColors.seedGrey50),
      _ColorItem(name: 'seedGrey70', color: IoFlipColors.seedGrey70),
      _ColorItem(name: 'seedGrey80', color: IoFlipColors.seedGrey80),
      _ColorItem(name: 'seedGrey90', color: IoFlipColors.seedGrey90),
      _ColorItem(name: 'seedWhite', color: IoFlipColors.seedWhite),
      _ColorItem(name: 'seedScrim', color: IoFlipColors.seedScrim),
      _ColorItem(
        name: 'seedPaletteLightBlue0',
        color: IoFlipColors.seedPaletteLightBlue0,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue10',
        color: IoFlipColors.seedPaletteLightBlue10,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue20',
        color: IoFlipColors.seedPaletteLightBlue20,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue30',
        color: IoFlipColors.seedPaletteLightBlue30,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue40',
        color: IoFlipColors.seedPaletteLightBlue40,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue50',
        color: IoFlipColors.seedPaletteLightBlue50,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue60',
        color: IoFlipColors.seedPaletteLightBlue60,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue70',
        color: IoFlipColors.seedPaletteLightBlue70,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue80',
        color: IoFlipColors.seedPaletteLightBlue80,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue90',
        color: IoFlipColors.seedPaletteLightBlue90,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue95',
        color: IoFlipColors.seedPaletteLightBlue95,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue99',
        color: IoFlipColors.seedPaletteLightBlue99,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue100',
        color: IoFlipColors.seedPaletteLightBlue100,
      ),
      _ColorItem(
        name: 'seedPaletteBlue0',
        color: IoFlipColors.seedPaletteBlue0,
      ),
      _ColorItem(
        name: 'seedPaletteBlue10',
        color: IoFlipColors.seedPaletteBlue10,
      ),
      _ColorItem(
        name: 'seedPaletteBlue20',
        color: IoFlipColors.seedPaletteBlue20,
      ),
      _ColorItem(
        name: 'seedPaletteBlue30',
        color: IoFlipColors.seedPaletteBlue30,
      ),
      _ColorItem(
        name: 'seedPaletteBlue40',
        color: IoFlipColors.seedPaletteBlue40,
      ),
      _ColorItem(
        name: 'seedPaletteBlue50',
        color: IoFlipColors.seedPaletteBlue50,
      ),
      _ColorItem(
        name: 'seedPaletteBlue60',
        color: IoFlipColors.seedPaletteBlue60,
      ),
      _ColorItem(
        name: 'seedPaletteBlue70',
        color: IoFlipColors.seedPaletteBlue70,
      ),
      _ColorItem(
        name: 'seedPaletteBlue80',
        color: IoFlipColors.seedPaletteBlue80,
      ),
      _ColorItem(
        name: 'seedPaletteBlue90',
        color: IoFlipColors.seedPaletteBlue90,
      ),
      _ColorItem(
        name: 'seedPaletteBlue95',
        color: IoFlipColors.seedPaletteBlue95,
      ),
      _ColorItem(
        name: 'seedPaletteBlue99',
        color: IoFlipColors.seedPaletteBlue99,
      ),
      _ColorItem(
        name: 'seedPaletteBlue100',
        color: IoFlipColors.seedPaletteBlue100,
      ),
      _ColorItem(name: 'seedPaletteRed0', color: IoFlipColors.seedPaletteRed0),
      _ColorItem(
        name: 'seedPaletteRed10',
        color: IoFlipColors.seedPaletteRed10,
      ),
      _ColorItem(
        name: 'seedPaletteRed20',
        color: IoFlipColors.seedPaletteRed20,
      ),
      _ColorItem(
        name: 'seedPaletteRed30',
        color: IoFlipColors.seedPaletteRed30,
      ),
      _ColorItem(
        name: 'seedPaletteRed40',
        color: IoFlipColors.seedPaletteRed40,
      ),
      _ColorItem(
        name: 'seedPaletteRed50',
        color: IoFlipColors.seedPaletteRed50,
      ),
      _ColorItem(
        name: 'seedPaletteRed60',
        color: IoFlipColors.seedPaletteRed60,
      ),
      _ColorItem(
        name: 'seedPaletteRed70',
        color: IoFlipColors.seedPaletteRed70,
      ),
      _ColorItem(
        name: 'seedPaletteRed80',
        color: IoFlipColors.seedPaletteRed80,
      ),
      _ColorItem(
        name: 'seedPaletteRed90',
        color: IoFlipColors.seedPaletteRed90,
      ),
      _ColorItem(
        name: 'seedPaletteRed95',
        color: IoFlipColors.seedPaletteRed95,
      ),
      _ColorItem(
        name: 'seedPaletteRed99',
        color: IoFlipColors.seedPaletteRed99,
      ),
      _ColorItem(
        name: 'seedPaletteRed100',
        color: IoFlipColors.seedPaletteRed100,
      ),
      _ColorItem(
        name: 'seedPaletteGreen0',
        color: IoFlipColors.seedPaletteGreen0,
      ),
      _ColorItem(
        name: 'seedPaletteGreen10',
        color: IoFlipColors.seedPaletteGreen10,
      ),
      _ColorItem(
        name: 'seedPaletteGreen20',
        color: IoFlipColors.seedPaletteGreen20,
      ),
      _ColorItem(
        name: 'seedPaletteGreen30',
        color: IoFlipColors.seedPaletteGreen30,
      ),
      _ColorItem(
        name: 'seedPaletteGreen40',
        color: IoFlipColors.seedPaletteGreen40,
      ),
      _ColorItem(
        name: 'seedPaletteGreen50',
        color: IoFlipColors.seedPaletteGreen50,
      ),
      _ColorItem(
        name: 'seedPaletteGreen60',
        color: IoFlipColors.seedPaletteGreen60,
      ),
      _ColorItem(
        name: 'seedPaletteGreen70',
        color: IoFlipColors.seedPaletteGreen70,
      ),
      _ColorItem(
        name: 'seedPaletteGreen80',
        color: IoFlipColors.seedPaletteGreen80,
      ),
      _ColorItem(
        name: 'seedPaletteGreen90',
        color: IoFlipColors.seedPaletteGreen90,
      ),
      _ColorItem(
        name: 'seedPaletteGreen95',
        color: IoFlipColors.seedPaletteGreen95,
      ),
      _ColorItem(
        name: 'seedPaletteGreen99',
        color: IoFlipColors.seedPaletteGreen99,
      ),
      _ColorItem(
        name: 'seedPaletteGreen100',
        color: IoFlipColors.seedPaletteGreen100,
      ),
      _ColorItem(
        name: 'seedPaletteYellow0',
        color: IoFlipColors.seedPaletteYellow0,
      ),
      _ColorItem(
        name: 'seedPaletteYellow10',
        color: IoFlipColors.seedPaletteYellow10,
      ),
      _ColorItem(
        name: 'seedPaletteYellow20',
        color: IoFlipColors.seedPaletteYellow20,
      ),
      _ColorItem(
        name: 'seedPaletteYellow30',
        color: IoFlipColors.seedPaletteYellow30,
      ),
      _ColorItem(
        name: 'seedPaletteYellow40',
        color: IoFlipColors.seedPaletteYellow40,
      ),
      _ColorItem(
        name: 'seedPaletteYellow50',
        color: IoFlipColors.seedPaletteYellow50,
      ),
      _ColorItem(
        name: 'seedPaletteYellow60',
        color: IoFlipColors.seedPaletteYellow60,
      ),
      _ColorItem(
        name: 'seedPaletteYellow70',
        color: IoFlipColors.seedPaletteYellow70,
      ),
      _ColorItem(
        name: 'seedPaletteYellow80',
        color: IoFlipColors.seedPaletteYellow80,
      ),
      _ColorItem(
        name: 'seedPaletteYellow90',
        color: IoFlipColors.seedPaletteYellow90,
      ),
      _ColorItem(
        name: 'seedPaletteYellow95',
        color: IoFlipColors.seedPaletteYellow95,
      ),
      _ColorItem(
        name: 'seedPaletteYellow99',
        color: IoFlipColors.seedPaletteYellow99,
      ),
      _ColorItem(
        name: 'seedPaletteYellow100',
        color: IoFlipColors.seedPaletteYellow100,
      ),
      _ColorItem(
        name: 'seedPaletteBrown0',
        color: IoFlipColors.seedPaletteBrown0,
      ),
      _ColorItem(
        name: 'seedPaletteBrown10',
        color: IoFlipColors.seedPaletteBrown10,
      ),
      _ColorItem(
        name: 'seedPaletteBrown20',
        color: IoFlipColors.seedPaletteBrown20,
      ),
      _ColorItem(
        name: 'seedPaletteBrown30',
        color: IoFlipColors.seedPaletteBrown30,
      ),
      _ColorItem(
        name: 'seedPaletteBrown40',
        color: IoFlipColors.seedPaletteBrown40,
      ),
      _ColorItem(
        name: 'seedPaletteBrown50',
        color: IoFlipColors.seedPaletteBrown50,
      ),
      _ColorItem(
        name: 'seedPaletteBrown60',
        color: IoFlipColors.seedPaletteBrown60,
      ),
      _ColorItem(
        name: 'seedPaletteBrown70',
        color: IoFlipColors.seedPaletteBrown70,
      ),
      _ColorItem(
        name: 'seedPaletteBrown80',
        color: IoFlipColors.seedPaletteBrown80,
      ),
      _ColorItem(
        name: 'seedPaletteBrown90',
        color: IoFlipColors.seedPaletteBrown90,
      ),
      _ColorItem(
        name: 'seedPaletteBrown95',
        color: IoFlipColors.seedPaletteBrown95,
      ),
      _ColorItem(
        name: 'seedPaletteBrown99',
        color: IoFlipColors.seedPaletteBrown99,
      ),
      _ColorItem(
        name: 'seedPaletteBrown100',
        color: IoFlipColors.seedPaletteBrown100,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral0',
        color: IoFlipColors.seedPaletteNeutral0,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral10',
        color: IoFlipColors.seedPaletteNeutral10,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral20',
        color: IoFlipColors.seedPaletteNeutral20,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral30',
        color: IoFlipColors.seedPaletteNeutral30,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral40',
        color: IoFlipColors.seedPaletteNeutral40,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral50',
        color: IoFlipColors.seedPaletteNeutral50,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral60',
        color: IoFlipColors.seedPaletteNeutral60,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral70',
        color: IoFlipColors.seedPaletteNeutral70,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral80',
        color: IoFlipColors.seedPaletteNeutral80,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral90',
        color: IoFlipColors.seedPaletteNeutral90,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral95',
        color: IoFlipColors.seedPaletteNeutral95,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral99',
        color: IoFlipColors.seedPaletteNeutral99,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral100',
        color: IoFlipColors.seedPaletteNeutral100,
      ),
      _ColorItem(
        name: 'seedArchiveGrey99',
        color: IoFlipColors.seedArchiveGrey99,
      ),
      _ColorItem(
        name: 'seedArchiveGrey95',
        color: IoFlipColors.seedArchiveGrey95,
      ),
      _ColorItem(name: 'accessibleBlack', color: IoFlipColors.accessibleBlack),
      _ColorItem(name: 'accessibleGrey', color: IoFlipColors.accessibleGrey),
      _ColorItem(
        name: 'accessibleBrandLightBlue',
        color: IoFlipColors.accessibleBrandLightBlue,
      ),
      _ColorItem(
        name: 'accessibleBrandBlue',
        color: IoFlipColors.accessibleBrandBlue,
      ),
      _ColorItem(
        name: 'accessibleBrandRed',
        color: IoFlipColors.accessibleBrandRed,
      ),
      _ColorItem(
        name: 'accessibleBrandYellow',
        color: IoFlipColors.accessibleBrandYellow,
      ),
      _ColorItem(
        name: 'accessibleBrandGreen',
        color: IoFlipColors.accessibleBrandGreen,
      ),
    ];

    return const StoryScaffold(
      title: 'Colors',
      body: SingleChildScrollView(
        child: Wrap(
          children: colorItems,
        ),
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name),
          const SizedBox(height: 16),
          _ColorSquare(color: color),
        ],
      ),
    );
  }
}

class _ColorSquare extends StatelessWidget {
  const _ColorSquare({required this.color});

  final Color color;

  TextStyle get textStyle {
    return TextStyle(
      color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );
  }

  String get hexCode {
    if (color.value.toRadixString(16).length <= 2) {
      return '--';
    } else {
      return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Stack(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, border: Border.all()),
            ),
          ),
          Positioned.fill(
            child: Center(child: Text(hexCode, style: textStyle)),
          ),
        ],
      ),
    );
  }
}
