// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

void main() {
  blocTest<InitialsFormBloc, InitialsFormState>(
    'emits state with updated initials when changing them',
    build: InitialsFormBloc.new,
    act: (bloc) => bloc.add(InitialsChanged(initials: 'ABC')),
    expect: () => <InitialsFormState>[
      InitialsFormState(initials: 'ABC'),
    ],
  );

  blocTest<InitialsFormBloc, InitialsFormState>(
    'emits state with validated field when initials are valid and submitted',
    build: InitialsFormBloc.new,
    act: (bloc) {
      bloc
        ..add(InitialsChanged(initials: 'ABC'))
        ..add(InitialsSubmitted());
    },
    expect: () => <InitialsFormState>[
      InitialsFormState(initials: 'ABC'),
      InitialsFormState(initials: 'ABC', status: InitialsFormStatus.valid),
    ],
  );

  blocTest<InitialsFormBloc, InitialsFormState>(
    'emits state with invalid field when initials are not valid and submitted',
    build: InitialsFormBloc.new,
    act: (bloc) {
      bloc
        ..add(InitialsChanged(initials: 'WTF'))
        ..add(InitialsSubmitted());
    },
    expect: () => <InitialsFormState>[
      InitialsFormState(initials: 'WTF'),
      InitialsFormState(initials: 'WTF', status: InitialsFormStatus.invalid),
    ],
  );
}
