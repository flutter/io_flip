// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

void main() {
  blocTest<InitialsFormBloc, InitialsFormState>(
    'emits state with updated initials when changing them',
    build: InitialsFormBloc.new,
    act: (bloc) => bloc.add(InitialsChanged(initials: 'ABC')),
    expect: () => <InitialsFormState>[
      InitialsFormState(initials: Initials.dirty('ABC')),
    ],
  );
}
