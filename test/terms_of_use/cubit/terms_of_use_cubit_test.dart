import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/terms_of_use/terms_of_use.dart';

void main() {
  group('TermsOfUseCubit', () {
    late TermsOfUseCubit cubit;

    setUp(() => cubit = TermsOfUseCubit());

    test('initial state is false', () {
      expect(cubit.state, isFalse);
    });

    blocTest<TermsOfUseCubit, bool>(
      'emits [true] when acceptTermsOfUse is called',
      build: () => cubit,
      act: (cubit) => cubit.acceptTermsOfUse(),
      expect: () => [true],
    );
  });
}
