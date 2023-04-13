part of 'how_to_play_bloc.dart';

class HowToPlayState extends Equatable {
  const HowToPlayState({
    this.position = 0,
    this.elementsWheelState = const ElementsWheelFire(),
  });

  final int position;
  final ElementsWheelState elementsWheelState;

  static const initialSteps = <Widget>[
    HowToPlayIntro(),
    HowToPlayHandBuilding(),
    HowToPlayElementsIntro(),
  ];

  int get totalSteps =>
      HowToPlayState.initialSteps.length + Elements.values.length;

  @override
  List<Object> get props => [position, elementsWheelState];

  HowToPlayState copyWith({
    int? position,
    ElementsWheelState? elementsWheelState,
  }) {
    return HowToPlayState(
      position: position ?? this.position,
      elementsWheelState: elementsWheelState ?? this.elementsWheelState,
    );
  }
}

abstract class ElementsWheelState extends Equatable {
  const ElementsWheelState({
    required this.allElements,
    required this.elementsAffected,
  });

  final List<Elements> allElements;
  final List<Elements> elementsAffected;

  String Function(AppLocalizations) get text;

  @override
  List<Object> get props => [allElements, elementsAffected];

  List<int> get affectedIndicatorIndexes {
    return elementsAffected.map((e) => allElements.indexOf(e) - 1).toList();
  }

  ElementsWheelState get next;
}

class ElementsWheelFire extends ElementsWheelState {
  const ElementsWheelFire()
      : super(
          allElements: const [
            Elements.fire,
            Elements.air,
            Elements.metal,
            Elements.earth,
            Elements.water,
          ],
          elementsAffected: const [
            Elements.air,
            Elements.metal,
          ],
        );

  @override
  ElementsWheelState get next => const ElementsWheelAir();

  @override
  String Function(AppLocalizations) get text =>
      (l10n) => l10n.howToPlayElementsFireTitle;
}

class ElementsWheelAir extends ElementsWheelState {
  const ElementsWheelAir()
      : super(
          allElements: const [
            Elements.air,
            Elements.metal,
            Elements.earth,
            Elements.water,
            Elements.fire,
          ],
          elementsAffected: const [
            Elements.water,
            Elements.earth,
          ],
        );

  @override
  ElementsWheelState get next => const ElementsWheelMetal();

  @override
  String Function(AppLocalizations) get text =>
      (l10n) => l10n.howToPlayElementsAirTitle;
}

class ElementsWheelMetal extends ElementsWheelState {
  const ElementsWheelMetal()
      : super(
          allElements: const [
            Elements.metal,
            Elements.earth,
            Elements.water,
            Elements.fire,
            Elements.air,
          ],
          elementsAffected: const [
            Elements.air,
            Elements.water,
          ],
        );

  @override
  ElementsWheelState get next => const ElementsWheelEarth();

  @override
  String Function(AppLocalizations) get text =>
      (l10n) => l10n.howToPlayElementsMetalTitle;
}

class ElementsWheelEarth extends ElementsWheelState {
  const ElementsWheelEarth()
      : super(
          allElements: const [
            Elements.earth,
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
          ],
          elementsAffected: const [
            Elements.fire,
            Elements.metal,
          ],
        );

  @override
  ElementsWheelState get next => const ElementsWheelWater();

  @override
  String Function(AppLocalizations) get text =>
      (l10n) => l10n.howToPlayElementsEarthTitle;
}

class ElementsWheelWater extends ElementsWheelState {
  const ElementsWheelWater()
      : super(
          allElements: const [
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
            Elements.earth,
          ],
          elementsAffected: const [
            Elements.fire,
            Elements.earth,
          ],
        );

  @override
  ElementsWheelState get next => const ElementsWheelFire();

  @override
  String Function(AppLocalizations) get text =>
      (l10n) => l10n.howToPlayElementsWaterTitle;
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

  Alignment get initialAlignment {
    switch (this) {
      case fire:
        return ElementAlignment.topCenter;
      case air:
        return ElementAlignment.centerRight;
      case metal:
        return ElementAlignment.bottomRight;
      case earth:
        return ElementAlignment.bottomLeft;
      case water:
        return ElementAlignment.centerLeft;
    }
  }
}

class ElementAlignment {
  static const Alignment topCenter = Alignment.topCenter;

  static const Alignment centerRight = Alignment(1, -.1);

  static const Alignment centerLeft = Alignment(-1, -.1);

  static const Alignment bottomRight = Alignment(.6, 1);

  static const Alignment bottomLeft = Alignment(-.6, 1);
}
