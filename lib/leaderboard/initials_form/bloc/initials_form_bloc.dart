import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

part 'initials_form_event.dart';
part 'initials_form_state.dart';

class InitialsFormBloc extends Bloc<InitialsFormEvent, InitialsFormState> {
  InitialsFormBloc() : super(InitialsFormState()) {
    on<InitialsChanged>(_onInitialsChanged);
  }

  void _onInitialsChanged(
    InitialsChanged event,
    Emitter<InitialsFormState> emit,
  ) {
    final initials = Initials.dirty(event.initials);
    emit(state.copyWith(initials: initials));
  }
}
