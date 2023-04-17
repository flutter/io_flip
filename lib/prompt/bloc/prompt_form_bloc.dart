import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'prompt_form_event.dart';
part 'prompt_form_state.dart';

class PromptFormBloc extends Bloc<PromptFormEvent, PromptFormState> {
  PromptFormBloc({
    required PromptResource promptResource,
  })  : _promptResource = promptResource,
        super(const PromptFormState.initial()) {
    on<PromptTermsRequested>(_onPromptTermsRequested);
    on<PromptSubmitted>(_onPromptSubmitted);
  }

  final PromptResource _promptResource;

  Future<void> _onPromptTermsRequested(
    PromptTermsRequested event,
    Emitter<PromptFormState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PromptTermsStatus.loading));

      final result = await Future.wait<List<String>>([
        _promptResource.getPromptTerms(PromptTermType.characterClass),
        _promptResource.getPromptTerms(PromptTermType.power),
        _promptResource.getPromptTerms(PromptTermType.secondaryPower),
      ]);

      emit(
        state.copyWith(
          characterClasses: result[0],
          powers: result[1],
          secondaryPowers: result[2],
          status: PromptTermsStatus.loaded,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: PromptTermsStatus.failed));
    }
  }

  void _onPromptSubmitted(
    PromptSubmitted event,
    Emitter<PromptFormState> emit,
  ) {
    emit(state.copyWith(prompts: event.data));
  }
}
