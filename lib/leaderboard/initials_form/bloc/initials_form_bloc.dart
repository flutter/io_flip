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
    final initials = [...state.initials];
    initials[event.index] = event.initial;
    final status = (state.status == InitialsFormStatus.blacklisted)
        ? InitialsFormStatus.initial
        : state.status;
    emit(state.copyWith(initials: initials, status: status));
  }

  Future<void> _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<InitialsFormState> emit,
  ) async {
    try {
      if (!_hasValidPattern()) {
        emit(state.copyWith(status: InitialsFormStatus.invalid));
      } else if (_isBlacklisted()) {
        emit(state.copyWith(status: InitialsFormStatus.blacklisted));
      } else {
        emit(state.copyWith(status: InitialsFormStatus.valid));

        await _leaderboardResource.addInitialsToScoreCard(
          scoreCardId: _scoreCardId,
          initials: state.initials.join(),
        );

        emit(state.copyWith(status: InitialsFormStatus.success));
      }
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: InitialsFormStatus.failure));
    }
  }

  bool _hasValidPattern() {
    final value = state.initials;
    return value.isNotEmpty && initialsRegex.hasMatch(value.join());
  }

  bool _isBlacklisted() {
    return blacklist.contains(state.initials.join());
  }
}
