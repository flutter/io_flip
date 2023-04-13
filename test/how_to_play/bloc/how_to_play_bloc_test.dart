// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';

void main() {
  group('HowToPlayBloc', () {
    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 1 to step 2 when requesting next page',
      build: HowToPlayBloc.new,
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(position: 1),
      ],
    );

    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 2 to step 3 when requesting next page',
      build: HowToPlayBloc.new,
      seed: () => HowToPlayState(position: 1),
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(position: 2),
      ],
    );

    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 3 to step 4 when requesting next page',
      build: HowToPlayBloc.new,
      seed: () => HowToPlayState(position: 2),
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(position: 3),
      ],
    );

    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 4 to step 5 when requesting next page',
      build: HowToPlayBloc.new,
      seed: () => HowToPlayState(position: 3),
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(
          position: 4,
          elementsWheelState: ElementsWheelAir(),
        ),
      ],
    );

    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 5 to step 6 when requesting next page',
      build: HowToPlayBloc.new,
      seed: () => HowToPlayState(
        position: 4,
        elementsWheelState: ElementsWheelAir(),
      ),
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(
          position: 5,
          elementsWheelState: ElementsWheelMetal(),
        ),
      ],
    );

    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 6 to step 7 when requesting next page',
      build: HowToPlayBloc.new,
      seed: () => HowToPlayState(
        position: 5,
        elementsWheelState: ElementsWheelMetal(),
      ),
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(
          position: 6,
          elementsWheelState: ElementsWheelEarth(),
        ),
      ],
    );

    blocTest<HowToPlayBloc, HowToPlayState>(
      'changes from step 7 to step 8 when requesting next page',
      build: HowToPlayBloc.new,
      seed: () => HowToPlayState(
        position: 6,
        elementsWheelState: ElementsWheelEarth(),
      ),
      act: (bloc) => bloc.add(NextPageRequested()),
      expect: () => [
        HowToPlayState(
          position: 7,
          elementsWheelState: ElementsWheelWater(),
        ),
      ],
    );
  });
}
