import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'initials_form_event.dart';
part 'initials_form_state.dart';

class InitialsFormBloc extends Bloc<InitialsFormEvent, InitialsFormState> {
  InitialsFormBloc() : super(const InitialsFormState()) {
    _setBlacklist();
    on<InitialsChanged>(_onInitialsChanged);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final initialsRegex = RegExp('[A-Z]{3}');
  late final List<String> blacklist;

  Future<void> _setBlacklist() async {
    blacklist = ['WTF'];
  }

  void _onInitialsChanged(
    InitialsChanged event,
    Emitter<InitialsFormState> emit,
  ) {
    emit(state.copyWith(initials: event.initials));
  }

  void _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<InitialsFormState> emit,
  ) {
    if (_validate()) {
      emit(state.copyWith(status: InitialsFormStatus.valid));
      // Here goes the submission logic
    } else {
      emit(state.copyWith(status: InitialsFormStatus.invalid));
    }
  }

  bool _validate() {
    final value = state.initials;
    return value.isNotEmpty &&
        initialsRegex.hasMatch(value) &&
        !blacklist.contains(value);
  }
}
