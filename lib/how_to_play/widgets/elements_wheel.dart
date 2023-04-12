import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ElementsWheel extends StatelessWidget {
  const ElementsWheel({
    required this.allElements,
    required this.affectedIndexes,
    required this.text,
    super.key,
  }) : assert(
          allElements.length == 5,
          '5 elements must be present in the wheel',
        );

  final List<Elements> allElements;
  final List<int> affectedIndexes;
  final String text;

  static const size = 300.0;
  static const iconSize = 100;
  static const List<Alignment> alignments = [
    Alignment.topCenter,
    Alignment(1, -.1),
    Alignment(.6, 1),
    Alignment(-.6, 1),
    Alignment(-1, -.1),
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
          height: size,
          width: size,
          child: Stack(
            children: [
              ...allElements.mapIndexed(
                (index, element) {
                  return _ElementItem(
                    key: ValueKey(element),
                    alignment: alignments[index],
                    isReference: index == 0,
                    isAffected: affectedIndexes.contains(index - 1),
                    child: element.icon,
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

class _ElementItem extends StatelessWidget {
  const _ElementItem({
    required this.alignment,
    required this.isReference,
    required this.isAffected,
    required this.child,
    super.key,
  });

  final Alignment alignment;
  final bool isReference;
  final bool isAffected;
  final ElementIcon child;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: transitionDuration,
      alignment: alignment,
      child: Builder(
        builder: (context) {
          return AnimatedOpacity(
            opacity: isAffected || isReference ? 1 : .2,
            duration: transitionDuration,
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

  static const size = 300.0;
  static const iconSize = 100;

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
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: TopDashColors.seedRed,
        boxShadow: const [
          BoxShadow(
            offset: Offset(-2, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(TopDashSpacing.xs),
        child: Icon(Icons.arrow_downward, size: 22),
      ),
    );
  }
}
