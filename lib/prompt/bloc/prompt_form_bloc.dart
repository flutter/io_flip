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
        super(const PromptFormState()) {
    _setWhitelist();
    on<PromptSubmitted>(_onPromptSubmitted);
  }

  final PromptResource _promptResource;
  late final List<String> whitelist;

  Future<void> _setWhitelist() async {
    whitelist = await _promptResource.getPromptWhitelist();
  }

  void _onPromptSubmitted(
    PromptSubmitted event,
    Emitter<PromptFormState> emit,
  ) {
    emit(state.copyWith(prompts: event.data));
  }
}
