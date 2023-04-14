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
    _setTermsLists();
    on<PromptSubmitted>(_onPromptSubmitted);
  }

  final PromptResource _promptResource;
  late final List<String> characterClassList;
  late final List<String> powerList;
  late final List<String> secondaryPowerList;

  Future<void> _setTermsLists() async {
    final result = await Future.wait<List<String>>([
      _promptResource.getPromptTerms(PromptTermType.characterClass),
      _promptResource.getPromptTerms(PromptTermType.power),
      _promptResource.getPromptTerms(PromptTermType.secondaryPower),
    ]);
    characterClassList = result[0];
    powerList = result[1];
    secondaryPowerList = result[2];
  }

  void _onPromptSubmitted(
    PromptSubmitted event,
    Emitter<PromptFormState> emit,
  ) {
    emit(state.copyWith(prompts: event.data));
  }
}
