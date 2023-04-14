import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

const transitionDuration = Duration(milliseconds: 400);
const suitsWheelSize = 300.0;

class SuitsWheel extends StatelessWidget {
  const SuitsWheel({
    required this.suits,
    required this.affectedIndexes,
    required this.text,
    super.key,
  }) : assert(
          suits.length == 5,
          '5 suits must be present in the wheel',
        );

  final List<Suit> suits;
  final List<int> affectedIndexes;
  final String text;

  static const List<Alignment> alignments = [
    SuitAlignment.topCenter,
    SuitAlignment.centerRight,
    SuitAlignment.bottomRight,
    SuitAlignment.bottomLeft,
    SuitAlignment.centerLeft,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxlg),
        FadeAnimatedSwitcher(
          duration: transitionDuration,
          child: HowToPlayStyledText(
            text,
            key: ValueKey(text),
          ),
        ),
        const SizedBox(height: TopDashSpacing.lg),
        SizedBox(
          height: suitsWheelSize,
          width: suitsWheelSize,
          child: Stack(
            children: [
              ...suits.mapIndexed(
                (index, suit) {
                  return SuitItem(
                    key: ValueKey(suit),
                    initialAlignment: suit.initialAlignment,
                    alignment: alignments[index],
                    isReference: index == 0,
                    isAffected: affectedIndexes.contains(index - 1),
                    child: suit.icon,
                  );
                },
              ),
              _AffectedArrows(affectedIndexes),
              _AffectedIndicators(affectedIndexes)
            ],
          ),
        ),
      ],
    );
  }
}

class SuitItem extends StatelessWidget {
  const SuitItem({
    required this.initialAlignment,
    required this.alignment,
    required this.isReference,
    required this.isAffected,
    required this.child,
    super.key,
  });

  final Alignment initialAlignment;
  final Alignment alignment;
  final bool isReference;
  final bool isAffected;
  final SuitIcon child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Alignment>(
      duration: transitionDuration,
      curve: const Cubic(.1, 0, .2, 1),
      tween: CircularAlignmentTween(begin: initialAlignment, end: alignment),
      builder: (context, alignment, child) => Align(
        alignment: alignment,
        child: child,
      ),
      child: TweenAnimationBuilder<double>(
        duration: transitionDuration,
        tween: Tween<double>(
          begin: isAffected ? 1 : 0,
          end: isAffected ? 1 : 0,
        ),
        builder: (_, number, __) {
          final color = TopDashColors.seedGrey80.withOpacity(number);
          return ColorFiltered(
            colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
            child: child,
          );
        },
      ),
    );
  }
}

class _AffectedArrows extends StatelessWidget {
  const _AffectedArrows(this.affectedIndexes);

  final List<int> affectedIndexes;

  static const size = suitsWheelSize;
  static const iconSize = 96;

  static const topPosition = Offset(size * .5, iconSize * .5);
  static const centerLeftPosition = Offset(iconSize * .5, size * .45);
  static const centerRightPosition = Offset(size - iconSize * .5, size * .45);
  static const bottomLeftPosition = Offset(size * .3, size - iconSize * .5);
  static const bottomRightPosition = Offset(size * .7, size - iconSize * .5);

  @override
  Widget build(BuildContext context) {
    final rightArrowStart = getMidpoint(topPosition, centerRightPosition, .45);
    final rightArrowEnd = getMidpoint(topPosition, centerRightPosition, .65);
    final midRightArrowStart =
        getMidpoint(topPosition, bottomRightPosition, .35);
    final midRightArrowEnd = getMidpoint(topPosition, bottomRightPosition, .75);
    final midLeftArrowStart = getMidpoint(topPosition, bottomLeftPosition, .35);
    final midLeftArrowEnd = getMidpoint(topPosition, bottomLeftPosition, .75);
    final leftArrowStart = getMidpoint(topPosition, centerLeftPosition, .45);
    final leftArrowEnd = getMidpoint(topPosition, centerLeftPosition, .65);
    return Stack(
      children: [
        ArrowWidget(
          rightArrowStart,
          rightArrowEnd,
          visible: affectedIndexes.contains(0),
        ),
        ArrowWidget(
          midRightArrowStart,
          midRightArrowEnd,
          visible: affectedIndexes.contains(1),
        ),
        ArrowWidget(
          midLeftArrowStart,
          midLeftArrowEnd,
          visible: affectedIndexes.contains(2),
        ),
        ArrowWidget(
          leftArrowStart,
          leftArrowEnd,
          visible: affectedIndexes.contains(3),
        ),
      ],
    );
  }

  Offset getMidpoint(Offset p1, Offset p2, double distanceRatio) {
    return p1 + (p2 - p1) * distanceRatio;
  }
}

class _AffectedIndicators extends StatelessWidget {
  const _AffectedIndicators(this.affectedIndexes);

  final List<int> affectedIndexes;

  static const List<Alignment> alignments = [
    Alignment(1, -.25),
    Alignment(.7, .6),
    Alignment(-.7, .6),
    Alignment(-1, -.25),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: alignments
          .mapIndexed(
            (i, alignment) => AnimatedOpacity(
              duration: transitionDuration,
              opacity: affectedIndexes.contains(i) ? 1 : 0,
              child: Align(
                alignment: alignment,
                child: const _AffectedIndicator(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AffectedIndicator extends StatelessWidget {
  const _AffectedIndicator();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 4,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: TopDashColors.seedRed,
      ),
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.sm),
        child: SvgPicture.asset(
          Assets.icons.cancel,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

extension SuitsWheelX on Suit {
  SuitIcon get icon {
    switch (this) {
      case Suit.fire:
        return SuitIcon.fire();
      case Suit.water:
        return SuitIcon.water();
      case Suit.air:
        return SuitIcon.air();
      case Suit.earth:
        return SuitIcon.earth();
      case Suit.metal:
        return SuitIcon.metal();
    }
  }

  Alignment get initialAlignment {
    switch (this) {
      case Suit.fire:
        return SuitAlignment.topCenter;
      case Suit.water:
        return SuitAlignment.centerRight;
      case Suit.air:
        return SuitAlignment.bottomRight;
      case Suit.earth:
        return SuitAlignment.bottomLeft;
      case Suit.metal:
        return SuitAlignment.centerLeft;
    }
  }

  List<Suit> get suitsAffected {
    switch (this) {
      case Suit.fire:
        return [Suit.air, Suit.metal];
      case Suit.air:
        return [Suit.water, Suit.earth];
      case Suit.metal:
        return [Suit.air, Suit.water];
      case Suit.earth:
        return [Suit.fire, Suit.metal];
      case Suit.water:
        return [Suit.fire, Suit.earth];
    }
  }

  String Function(AppLocalizations) get text {
    switch (this) {
      case Suit.fire:
        return (l10n) => l10n.howToPlayElementsFireTitle;
      case Suit.air:
        return (l10n) => l10n.howToPlayElementsAirTitle;
      case Suit.metal:
        return (l10n) => l10n.howToPlayElementsMetalTitle;
      case Suit.earth:
        return (l10n) => l10n.howToPlayElementsEarthTitle;
      case Suit.water:
        return (l10n) => l10n.howToPlayElementsWaterTitle;
    }
  }
}

class SuitAlignment {
  static const Alignment topCenter = Alignment.topCenter;

  static const Alignment centerRight = Alignment(1, -.1);

  static const Alignment centerLeft = Alignment(-1, -.1);

  static const Alignment bottomRight = Alignment(.6, 1);

  static const Alignment bottomLeft = Alignment(-.6, 1);
}
