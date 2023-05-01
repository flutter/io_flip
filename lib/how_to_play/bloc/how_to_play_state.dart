part of 'how_to_play_bloc.dart';

class HowToPlayState extends Equatable {
  const HowToPlayState({
    this.position = 0,
    this.wheelSuits = const [
      Suit.fire,
      Suit.air,
      Suit.metal,
      Suit.earth,
      Suit.water,
    ],
  });

  final int position;
  final List<Suit> wheelSuits;

  static const steps = <Widget>[
    HowToPlayIntro(),
    HowToPlayHandBuilding(),
    HowToPlaySuitsIntro(),
  ];

  int get totalSteps => steps.length + wheelSuits.length;

  List<int> get affectedIndicatorIndexes {
    return wheelSuits.first.suitsAffected
        .map((e) => wheelSuits.indexOf(e) - 1)
        .toList();
  }

  @override
  List<Object> get props => [position, wheelSuits];

  HowToPlayState copyWith({
    int? position,
    List<Suit>? wheelSuits,
  }) {
    return HowToPlayState(
      position: position ?? this.position,
      wheelSuits: wheelSuits ?? this.wheelSuits,
    );
  }
}
