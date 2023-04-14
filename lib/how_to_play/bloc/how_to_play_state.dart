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

  static const initialSteps = <Widget>[
    HowToPlayIntro(),
    HowToPlayHandBuilding(),
    HowToPlaySuitsIntro(),
  ];

  static const finalSteps = <Widget>[
    HowToPlaySummary(),
  ];

  int get totalSteps =>
      HowToPlayState.initialSteps.length +
      wheelSuits.length +
      HowToPlayState.finalSteps.length;

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
