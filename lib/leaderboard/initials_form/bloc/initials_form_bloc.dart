import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'initials_form_event.dart';
part 'initials_form_state.dart';

class InitialsFormBloc extends Bloc<InitialsFormEvent, InitialsFormState> {
  InitialsFormBloc({
    required LeaderboardResource leaderboardResource,
    required String scoreCardId,
  })  : _leaderboardResource = leaderboardResource,
        _scoreCardId = scoreCardId,
        super(const InitialsFormState()) {
    _setBlacklist();
    on<InitialsChanged>(_onInitialsChanged);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final LeaderboardResource _leaderboardResource;
  final initialsRegex = RegExp('[A-Z]{3}');
  late final List<String> blacklist;
  late final String _scoreCardId;

  Future<void> _setBlacklist() async {
    blacklist = await _leaderboardResource.getInitialsBlacklist();
  }

  void _onInitialsChanged(
    InitialsChanged event,
    Emitter<InitialsFormState> emit,
  ) {
    emit(state.copyWith(initials: event.initials));
  }

  Future<void> _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<InitialsFormState> emit,
  ) async {
    try {
      if (_validate()) {
        emit(state.copyWith(status: InitialsFormStatus.valid));

        await _leaderboardResource.addInitialsToScoreCard(
          scoreCardId: _scoreCardId,
          initials: state.initials,
        );

        emit(state.copyWith(status: InitialsFormStatus.success));
      } else {
        emit(state.copyWith(status: InitialsFormStatus.invalid));
      }
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: InitialsFormStatus.failure));
    }
  }

  bool _validate() {
    final value = state.initials;
    return value.isNotEmpty &&
        initialsRegex.hasMatch(value) &&
        !blacklist.contains(value);
  }
}
