import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ElementsWheel extends StatelessWidget {
  const ElementsWheel({
    required this.allElements,
    required this.elementsAffected,
    super.key,
  }) : assert(
          allElements.length == 5,
          '5 elements must be present in the wheel',
        );

  final List<Elements> allElements;
  final List<Elements> elementsAffected;

  static const List<Alignment> alignments = [
    Alignment.topCenter,
    Alignment(-1, -.1),
    Alignment(1, -.1),
    Alignment(-.6, 1),
    Alignment(.6, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        children: allElements.mapIndexed(
          (index, element) {
            return _ElementItem(
              alignment: alignments[index],
              isReference: index == 0,
              isAffected: elementsAffected.contains(element),
              child: element.icon,
            );
          },
        ).toList(),
      ),
    );
  }
}

class _ElementItem extends StatelessWidget {
  const _ElementItem({
    required this.alignment,
    required this.isReference,
    required this.isAffected,
    required this.child,
  });

  final Alignment alignment;
  final bool isReference;
  final bool isAffected;
  final ElementIcon child;

  @override
  Widget build(BuildContext context) {
    if (isReference) return Align(alignment: alignment, child: child);
    if (isAffected) {
      return Align(
        alignment: alignment,
        child: SizedBox(
          height: child.height,
          width: child.width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                top: -5,
                right: alignment.x > 0 ? -5 : null,
                left: alignment.x < 0 ? -5 : null,
                child: const _AffectedIndicator(),
              ),
            ],
          ),
        ),
      );
    }
    return Align(
      alignment: alignment,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          TopDashColors.seedGrey50.withOpacity(.2),
          BlendMode.modulate,
        ),
        child: child,
      ),
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

enum Elements {
  fire,
  water,
  air,
  earth,
  metal;

  ElementIcon get icon {
    const scale = 1.3;
    switch (this) {
      case fire:
        return ElementIcon.fire(scale: scale);
      case water:
        return ElementIcon.water(scale: scale);
      case air:
        return ElementIcon.air(scale: scale);
      case earth:
        return ElementIcon.earth(scale: scale);
      case metal:
        return ElementIcon.metal(scale: scale);
    }
  }
}
