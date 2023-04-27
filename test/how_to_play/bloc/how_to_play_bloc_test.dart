// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';

void main() {
  group('HowToPlayBloc', () {
    group('NextPageRequested', () {
      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 1 to step 2',
        build: HowToPlayBloc.new,
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(position: 1),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 2 to step 3',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(position: 1),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(position: 2),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 3 to step 4',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(position: 2),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(position: 3),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 4 to step 5',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(position: 3),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 4,
            wheelSuits: const [
              Suit.air,
              Suit.metal,
              Suit.earth,
              Suit.water,
              Suit.fire,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 5 to step 6',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 4,
          wheelSuits: const [
            Suit.air,
            Suit.metal,
            Suit.earth,
            Suit.water,
            Suit.fire,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 5,
            wheelSuits: const [
              Suit.metal,
              Suit.earth,
              Suit.water,
              Suit.fire,
              Suit.air,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 6 to step 7',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 5,
          wheelSuits: const [
            Suit.metal,
            Suit.earth,
            Suit.water,
            Suit.fire,
            Suit.air,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 6,
            wheelSuits: const [
              Suit.earth,
              Suit.water,
              Suit.fire,
              Suit.air,
              Suit.metal,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 7 to step 8',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 6,
          wheelSuits: const [
            Suit.earth,
            Suit.water,
            Suit.fire,
            Suit.air,
            Suit.metal,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 7,
            wheelSuits: const [
              Suit.water,
              Suit.fire,
              Suit.air,
              Suit.metal,
              Suit.earth,
            ],
          ),
        ],
      );
    });

    group('PreviousPageRequested', () {
      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 8 to step 7',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 7,
          wheelSuits: const [
            Suit.water,
            Suit.fire,
            Suit.air,
            Suit.metal,
            Suit.earth,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 6,
            wheelSuits: const [
              Suit.earth,
              Suit.water,
              Suit.fire,
              Suit.air,
              Suit.metal,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 7 to step 6',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 6,
          wheelSuits: const [
            Suit.earth,
            Suit.water,
            Suit.fire,
            Suit.air,
            Suit.metal,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 5,
            wheelSuits: const [
              Suit.metal,
              Suit.earth,
              Suit.water,
              Suit.fire,
              Suit.air,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 6 to step 5',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 5,
          wheelSuits: const [
            Suit.metal,
            Suit.earth,
            Suit.water,
            Suit.fire,
            Suit.air,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 4,
            wheelSuits: const [
              Suit.air,
              Suit.metal,
              Suit.earth,
              Suit.water,
              Suit.fire,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 5 to step 4',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 4,
          wheelSuits: const [
            Suit.air,
            Suit.metal,
            Suit.earth,
            Suit.water,
            Suit.fire,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(position: 3),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 4 to step 3',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(position: 3),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(position: 2),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 3 to step 2',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(position: 2),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(position: 1),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 2 to step 1',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(position: 1),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(),
        ],
      );
    });
  });
}
