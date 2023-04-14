// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
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
            wheelElements: const [
              Elements.air,
              Elements.metal,
              Elements.earth,
              Elements.water,
              Elements.fire,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 5 to step 6',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 4,
          wheelElements: const [
            Elements.air,
            Elements.metal,
            Elements.earth,
            Elements.water,
            Elements.fire,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 5,
            wheelElements: const [
              Elements.metal,
              Elements.earth,
              Elements.water,
              Elements.fire,
              Elements.air,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 6 to step 7',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 5,
          wheelElements: const [
            Elements.metal,
            Elements.earth,
            Elements.water,
            Elements.fire,
            Elements.air,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 6,
            wheelElements: const [
              Elements.earth,
              Elements.water,
              Elements.fire,
              Elements.air,
              Elements.metal,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 7 to step 8',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 6,
          wheelElements: const [
            Elements.earth,
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 7,
            wheelElements: const [
              Elements.water,
              Elements.fire,
              Elements.air,
              Elements.metal,
              Elements.earth,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 8 to step 9',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 7,
          wheelElements: const [
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
            Elements.earth,
          ],
        ),
        act: (bloc) => bloc.add(NextPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 8,
            wheelElements: const [
              Elements.water,
              Elements.fire,
              Elements.air,
              Elements.metal,
              Elements.earth,
            ],
          ),
        ],
      );
    });

    group('PreviousPageRequested', () {
      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 9 to step 8',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 8,
          wheelElements: const [
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
            Elements.earth,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 7,
            wheelElements: const [
              Elements.water,
              Elements.fire,
              Elements.air,
              Elements.metal,
              Elements.earth,
            ],
          ),
        ],
      );
      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 8 to step 7',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 7,
          wheelElements: const [
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
            Elements.earth,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 6,
            wheelElements: const [
              Elements.earth,
              Elements.water,
              Elements.fire,
              Elements.air,
              Elements.metal,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 7 to step 6',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 6,
          wheelElements: const [
            Elements.earth,
            Elements.water,
            Elements.fire,
            Elements.air,
            Elements.metal,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 5,
            wheelElements: const [
              Elements.metal,
              Elements.earth,
              Elements.water,
              Elements.fire,
              Elements.air,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 6 to step 5',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 5,
          wheelElements: const [
            Elements.metal,
            Elements.earth,
            Elements.water,
            Elements.fire,
            Elements.air,
          ],
        ),
        act: (bloc) => bloc.add(PreviousPageRequested()),
        expect: () => [
          HowToPlayState(
            position: 4,
            wheelElements: const [
              Elements.air,
              Elements.metal,
              Elements.earth,
              Elements.water,
              Elements.fire,
            ],
          ),
        ],
      );

      blocTest<HowToPlayBloc, HowToPlayState>(
        'changes from step 5 to step 4',
        build: HowToPlayBloc.new,
        seed: () => HowToPlayState(
          position: 4,
          wheelElements: const [
            Elements.air,
            Elements.metal,
            Elements.earth,
            Elements.water,
            Elements.fire,
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
