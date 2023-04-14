part of 'how_to_play_bloc.dart';

class HowToPlayState extends Equatable {
  const HowToPlayState({
    this.position = 0,
    this.wheelElements = const [
      Elements.fire,
      Elements.air,
      Elements.metal,
      Elements.earth,
      Elements.water,
    ],
  });

  final int position;
  final List<Elements> wheelElements;

  static const initialSteps = <Widget>[
    HowToPlayIntro(),
    HowToPlayHandBuilding(),
    HowToPlayElementsIntro(),
  ];

  static const finalSteps = <Widget>[
    HowToPlaySummary(),
  ];

  int get totalSteps =>
      HowToPlayState.initialSteps.length +
      wheelElements.length +
      HowToPlayState.finalSteps.length;

  List<int> get affectedIndicatorIndexes {
    return wheelElements.first.elementsAffected
        .map((e) => wheelElements.indexOf(e) - 1)
        .toList();
  }

  @override
  List<Object> get props => [position, wheelElements];

  HowToPlayState copyWith({
    int? position,
    List<Elements>? wheelElements,
  }) {
    return HowToPlayState(
      position: position ?? this.position,
      wheelElements: wheelElements ?? this.wheelElements,
    );
  }
}

enum Elements {
  fire(initialAlignment: ElementAlignment.topCenter),
  air(initialAlignment: ElementAlignment.centerRight),
  metal(initialAlignment: ElementAlignment.bottomRight),
  earth(initialAlignment: ElementAlignment.bottomLeft),
  water(initialAlignment: ElementAlignment.centerLeft);

  const Elements({
    required this.initialAlignment,
  });

  final Alignment initialAlignment;

  ElementIcon get icon {
    switch (this) {
      case fire:
        return ElementIcon.fire();
      case water:
        return ElementIcon.water();
      case air:
        return ElementIcon.air();
      case earth:
        return ElementIcon.earth();
      case metal:
        return ElementIcon.metal();
    }
  }

  List<Elements> get elementsAffected {
    switch (this) {
      case fire:
        return [Elements.air, Elements.metal];
      case air:
        return [Elements.water, Elements.earth];
      case metal:
        return [Elements.air, Elements.water];
      case earth:
        return [Elements.fire, Elements.metal];
      case water:
        return [Elements.fire, Elements.earth];
    }
  }

  String Function(AppLocalizations) get text {
    switch (this) {
      case fire:
        return (l10n) => l10n.howToPlayElementsFireTitle;
      case air:
        return (l10n) => l10n.howToPlayElementsAirTitle;
      case metal:
        return (l10n) => l10n.howToPlayElementsMetalTitle;
      case earth:
        return (l10n) => l10n.howToPlayElementsEarthTitle;
      case water:
        return (l10n) => l10n.howToPlayElementsWaterTitle;
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
