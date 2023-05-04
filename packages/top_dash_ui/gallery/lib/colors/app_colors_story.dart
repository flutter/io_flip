import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class AppColorsStory extends StatelessWidget {
  const AppColorsStory({super.key});

  @override
  Widget build(BuildContext context) {
    const colorItems = [
      _ColorItem(name: 'gold', color: TopDashColors.seedGold),
      _ColorItem(name: 'silver', color: TopDashColors.seedSilver),
      _ColorItem(name: 'bronze', color: TopDashColors.seedBronze),
      _ColorItem(name: 'seedLightBlue', color: TopDashColors.seedLightBlue),
      _ColorItem(name: 'seedBlue', color: TopDashColors.seedBlue),
      _ColorItem(name: 'seedRed', color: TopDashColors.seedRed),
      _ColorItem(name: 'seedYellow', color: TopDashColors.seedYellow),
      _ColorItem(name: 'seedGreen', color: TopDashColors.seedGreen),
      _ColorItem(name: 'seedBrown', color: TopDashColors.seedBrown),
      _ColorItem(name: 'seedBlack', color: TopDashColors.seedBlack),
      _ColorItem(name: 'seedGrey30', color: TopDashColors.seedGrey30),
      _ColorItem(name: 'seedGrey50', color: TopDashColors.seedGrey50),
      _ColorItem(name: 'seedGrey70', color: TopDashColors.seedGrey70),
      _ColorItem(name: 'seedGrey80', color: TopDashColors.seedGrey80),
      _ColorItem(name: 'seedGrey90', color: TopDashColors.seedGrey90),
      _ColorItem(name: 'seedWhite', color: TopDashColors.seedWhite),
      _ColorItem(name: 'seedScrim', color: TopDashColors.seedScrim),
      _ColorItem(
        name: 'seedPaletteLightBlue0',
        color: TopDashColors.seedPaletteLightBlue0,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue10',
        color: TopDashColors.seedPaletteLightBlue10,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue20',
        color: TopDashColors.seedPaletteLightBlue20,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue30',
        color: TopDashColors.seedPaletteLightBlue30,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue40',
        color: TopDashColors.seedPaletteLightBlue40,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue50',
        color: TopDashColors.seedPaletteLightBlue50,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue60',
        color: TopDashColors.seedPaletteLightBlue60,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue70',
        color: TopDashColors.seedPaletteLightBlue70,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue80',
        color: TopDashColors.seedPaletteLightBlue80,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue90',
        color: TopDashColors.seedPaletteLightBlue90,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue95',
        color: TopDashColors.seedPaletteLightBlue95,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue99',
        color: TopDashColors.seedPaletteLightBlue99,
      ),
      _ColorItem(
        name: 'seedPaletteLightBlue100',
        color: TopDashColors.seedPaletteLightBlue100,
      ),
      _ColorItem(
        name: 'seedPaletteBlue0',
        color: TopDashColors.seedPaletteBlue0,
      ),
      _ColorItem(
        name: 'seedPaletteBlue10',
        color: TopDashColors.seedPaletteBlue10,
      ),
      _ColorItem(
        name: 'seedPaletteBlue20',
        color: TopDashColors.seedPaletteBlue20,
      ),
      _ColorItem(
        name: 'seedPaletteBlue30',
        color: TopDashColors.seedPaletteBlue30,
      ),
      _ColorItem(
        name: 'seedPaletteBlue40',
        color: TopDashColors.seedPaletteBlue40,
      ),
      _ColorItem(
        name: 'seedPaletteBlue50',
        color: TopDashColors.seedPaletteBlue50,
      ),
      _ColorItem(
        name: 'seedPaletteBlue60',
        color: TopDashColors.seedPaletteBlue60,
      ),
      _ColorItem(
        name: 'seedPaletteBlue70',
        color: TopDashColors.seedPaletteBlue70,
      ),
      _ColorItem(
        name: 'seedPaletteBlue80',
        color: TopDashColors.seedPaletteBlue80,
      ),
      _ColorItem(
        name: 'seedPaletteBlue90',
        color: TopDashColors.seedPaletteBlue90,
      ),
      _ColorItem(
        name: 'seedPaletteBlue95',
        color: TopDashColors.seedPaletteBlue95,
      ),
      _ColorItem(
        name: 'seedPaletteBlue99',
        color: TopDashColors.seedPaletteBlue99,
      ),
      _ColorItem(
        name: 'seedPaletteBlue100',
        color: TopDashColors.seedPaletteBlue100,
      ),
      _ColorItem(name: 'seedPaletteRed0', color: TopDashColors.seedPaletteRed0),
      _ColorItem(
        name: 'seedPaletteRed10',
        color: TopDashColors.seedPaletteRed10,
      ),
      _ColorItem(
        name: 'seedPaletteRed20',
        color: TopDashColors.seedPaletteRed20,
      ),
      _ColorItem(
        name: 'seedPaletteRed30',
        color: TopDashColors.seedPaletteRed30,
      ),
      _ColorItem(
        name: 'seedPaletteRed40',
        color: TopDashColors.seedPaletteRed40,
      ),
      _ColorItem(
        name: 'seedPaletteRed50',
        color: TopDashColors.seedPaletteRed50,
      ),
      _ColorItem(
        name: 'seedPaletteRed60',
        color: TopDashColors.seedPaletteRed60,
      ),
      _ColorItem(
        name: 'seedPaletteRed70',
        color: TopDashColors.seedPaletteRed70,
      ),
      _ColorItem(
        name: 'seedPaletteRed80',
        color: TopDashColors.seedPaletteRed80,
      ),
      _ColorItem(
        name: 'seedPaletteRed90',
        color: TopDashColors.seedPaletteRed90,
      ),
      _ColorItem(
        name: 'seedPaletteRed95',
        color: TopDashColors.seedPaletteRed95,
      ),
      _ColorItem(
        name: 'seedPaletteRed99',
        color: TopDashColors.seedPaletteRed99,
      ),
      _ColorItem(
        name: 'seedPaletteRed100',
        color: TopDashColors.seedPaletteRed100,
      ),
      _ColorItem(
        name: 'seedPaletteGreen0',
        color: TopDashColors.seedPaletteGreen0,
      ),
      _ColorItem(
        name: 'seedPaletteGreen10',
        color: TopDashColors.seedPaletteGreen10,
      ),
      _ColorItem(
        name: 'seedPaletteGreen20',
        color: TopDashColors.seedPaletteGreen20,
      ),
      _ColorItem(
        name: 'seedPaletteGreen30',
        color: TopDashColors.seedPaletteGreen30,
      ),
      _ColorItem(
        name: 'seedPaletteGreen40',
        color: TopDashColors.seedPaletteGreen40,
      ),
      _ColorItem(
        name: 'seedPaletteGreen50',
        color: TopDashColors.seedPaletteGreen50,
      ),
      _ColorItem(
        name: 'seedPaletteGreen60',
        color: TopDashColors.seedPaletteGreen60,
      ),
      _ColorItem(
        name: 'seedPaletteGreen70',
        color: TopDashColors.seedPaletteGreen70,
      ),
      _ColorItem(
        name: 'seedPaletteGreen80',
        color: TopDashColors.seedPaletteGreen80,
      ),
      _ColorItem(
        name: 'seedPaletteGreen90',
        color: TopDashColors.seedPaletteGreen90,
      ),
      _ColorItem(
        name: 'seedPaletteGreen95',
        color: TopDashColors.seedPaletteGreen95,
      ),
      _ColorItem(
        name: 'seedPaletteGreen99',
        color: TopDashColors.seedPaletteGreen99,
      ),
      _ColorItem(
        name: 'seedPaletteGreen100',
        color: TopDashColors.seedPaletteGreen100,
      ),
      _ColorItem(
        name: 'seedPaletteYellow0',
        color: TopDashColors.seedPaletteYellow0,
      ),
      _ColorItem(
        name: 'seedPaletteYellow10',
        color: TopDashColors.seedPaletteYellow10,
      ),
      _ColorItem(
        name: 'seedPaletteYellow20',
        color: TopDashColors.seedPaletteYellow20,
      ),
      _ColorItem(
        name: 'seedPaletteYellow30',
        color: TopDashColors.seedPaletteYellow30,
      ),
      _ColorItem(
        name: 'seedPaletteYellow40',
        color: TopDashColors.seedPaletteYellow40,
      ),
      _ColorItem(
        name: 'seedPaletteYellow50',
        color: TopDashColors.seedPaletteYellow50,
      ),
      _ColorItem(
        name: 'seedPaletteYellow60',
        color: TopDashColors.seedPaletteYellow60,
      ),
      _ColorItem(
        name: 'seedPaletteYellow70',
        color: TopDashColors.seedPaletteYellow70,
      ),
      _ColorItem(
        name: 'seedPaletteYellow80',
        color: TopDashColors.seedPaletteYellow80,
      ),
      _ColorItem(
        name: 'seedPaletteYellow90',
        color: TopDashColors.seedPaletteYellow90,
      ),
      _ColorItem(
        name: 'seedPaletteYellow95',
        color: TopDashColors.seedPaletteYellow95,
      ),
      _ColorItem(
        name: 'seedPaletteYellow99',
        color: TopDashColors.seedPaletteYellow99,
      ),
      _ColorItem(
        name: 'seedPaletteYellow100',
        color: TopDashColors.seedPaletteYellow100,
      ),
      _ColorItem(
        name: 'seedPaletteBrown0',
        color: TopDashColors.seedPaletteBrown0,
      ),
      _ColorItem(
        name: 'seedPaletteBrown10',
        color: TopDashColors.seedPaletteBrown10,
      ),
      _ColorItem(
        name: 'seedPaletteBrown20',
        color: TopDashColors.seedPaletteBrown20,
      ),
      _ColorItem(
        name: 'seedPaletteBrown30',
        color: TopDashColors.seedPaletteBrown30,
      ),
      _ColorItem(
        name: 'seedPaletteBrown40',
        color: TopDashColors.seedPaletteBrown40,
      ),
      _ColorItem(
        name: 'seedPaletteBrown50',
        color: TopDashColors.seedPaletteBrown50,
      ),
      _ColorItem(
        name: 'seedPaletteBrown60',
        color: TopDashColors.seedPaletteBrown60,
      ),
      _ColorItem(
        name: 'seedPaletteBrown70',
        color: TopDashColors.seedPaletteBrown70,
      ),
      _ColorItem(
        name: 'seedPaletteBrown80',
        color: TopDashColors.seedPaletteBrown80,
      ),
      _ColorItem(
        name: 'seedPaletteBrown90',
        color: TopDashColors.seedPaletteBrown90,
      ),
      _ColorItem(
        name: 'seedPaletteBrown95',
        color: TopDashColors.seedPaletteBrown95,
      ),
      _ColorItem(
        name: 'seedPaletteBrown99',
        color: TopDashColors.seedPaletteBrown99,
      ),
      _ColorItem(
        name: 'seedPaletteBrown100',
        color: TopDashColors.seedPaletteBrown100,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral0',
        color: TopDashColors.seedPaletteNeutral0,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral10',
        color: TopDashColors.seedPaletteNeutral10,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral20',
        color: TopDashColors.seedPaletteNeutral20,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral30',
        color: TopDashColors.seedPaletteNeutral30,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral40',
        color: TopDashColors.seedPaletteNeutral40,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral50',
        color: TopDashColors.seedPaletteNeutral50,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral60',
        color: TopDashColors.seedPaletteNeutral60,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral70',
        color: TopDashColors.seedPaletteNeutral70,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral80',
        color: TopDashColors.seedPaletteNeutral80,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral90',
        color: TopDashColors.seedPaletteNeutral90,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral95',
        color: TopDashColors.seedPaletteNeutral95,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral99',
        color: TopDashColors.seedPaletteNeutral99,
      ),
      _ColorItem(
        name: 'seedPaletteNeutral100',
        color: TopDashColors.seedPaletteNeutral100,
      ),
      _ColorItem(
        name: 'seedArchiveGrey99',
        color: TopDashColors.seedArchiveGrey99,
      ),
      _ColorItem(
        name: 'seedArchiveGrey95',
        color: TopDashColors.seedArchiveGrey95,
      ),
      _ColorItem(name: 'accessibleBlack', color: TopDashColors.accessibleBlack),
      _ColorItem(name: 'accessibleGrey', color: TopDashColors.accessibleGrey),
      _ColorItem(
        name: 'accessibleBrandLightBlue',
        color: TopDashColors.accessibleBrandLightBlue,
      ),
      _ColorItem(
        name: 'accessibleBrandBlue',
        color: TopDashColors.accessibleBrandBlue,
      ),
      _ColorItem(
        name: 'accessibleBrandRed',
        color: TopDashColors.accessibleBrandRed,
      ),
      _ColorItem(
        name: 'accessibleBrandYellow',
        color: TopDashColors.accessibleBrandYellow,
      ),
      _ColorItem(
        name: 'accessibleBrandGreen',
        color: TopDashColors.accessibleBrandGreen,
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
