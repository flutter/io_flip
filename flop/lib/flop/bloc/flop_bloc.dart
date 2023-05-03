// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flop/firebase_options_development.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

part 'flop_event.dart';
part 'flop_state.dart';

class FlopBloc extends Bloc<FlopEvent, FlopState> {
  FlopBloc({
    required this.setAppCheckDebugToken,
  }) : super(const FlopState.initial()) {
    on<NextStepRequested>(_onNextStepRequested);
  }

  final void Function(String) setAppCheckDebugToken;

  late AuthenticationRepository authenticationRepository;
  late ConnectionRepository connectionRepository;
  late MatchMakerRepository matchMakerRepository;
  late ApiClient apiClient;
  late bool isHost;
  late List<Card> cards;
  late String matchId;
  late String deckId;
  late String matchStateId;

  Future<void> initialize(Emitter<FlopState> emit) async {
    emit(state.withNewMessage('🤖 Hello, I am Flop and I am ready!'));

    const recaptchaKey = String.fromEnvironment('RECAPTCHA_KEY');
    const appCheckDebugToken = String.fromEnvironment('APPCHECK_DEBUG_TOKEN');

    setAppCheckDebugToken(appCheckDebugToken);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Ensure we always have a new user.
    await FirebaseAuth.instance.signOut();
    emit(state.withNewMessage('🔥 Firebase initialized'));

    final appCheck = FirebaseAppCheck.instance;
    await appCheck.activate(
      webRecaptchaSiteKey: recaptchaKey,
    );
    await appCheck.setTokenAutoRefreshEnabled(true);
    emit(state.withNewMessage('✅ AppCheck activated'));
  }

  Future<void> authenticate(Emitter<FlopState> emit) async {
    authenticationRepository = AuthenticationRepository(
      firebaseAuth: FirebaseAuth.instance,
    );

    final appCheck = FirebaseAppCheck.instance;
    apiClient = ApiClient(
      baseUrl: 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app',
      idTokenStream: authenticationRepository.idToken,
      refreshIdToken: authenticationRepository.refreshIdToken,
      appCheckTokenStream: appCheck.onTokenChange,
      appCheckToken: await appCheck.getToken(),
    );

    await authenticationRepository.signInAnonymously();
    await authenticationRepository.idToken.first;
    await authenticationRepository.user.first;

    connectionRepository = ConnectionRepository(
      apiClient: apiClient,
    );

    emit(state.withNewMessage('🎭 Authenticated anonymously'));
  }

  Future<void> generateCards(Emitter<FlopState> emit) async {
    final generatedCards = await apiClient.gameResource.generateCards(
      const Prompt(
        characterClass: 'Wizard',
        power: 'Chocolate',
      ),
    );
    emit(
      state.withNewMessage(
        '🃏 Generated ${generatedCards.length} cards\n '
        '${generatedCards.map((card) => ' - ${card.name}').join('\n ')}',
      ),
    );

    cards = (generatedCards..shuffle()).take(3).toList();
    emit(
      state.withNewMessage(
        '🃏 Choose 3 cards\n '
        '${cards.map((card) => ' - ${card.name}').join('\n ')}',
      ),
    );
  }

  Future<void> requestMatchConnection() async {
    final completer = Completer<void>();
    await connectionRepository.connect();

    late StreamSubscription<WebSocketMessage> subscription;
    subscription = connectionRepository.messages.listen(
      (message) {
        if (message.messageType == MessageType.connected) {
          completer.complete();
          subscription.cancel();
        }
      },
    );
    return completer.future;
  }

  Future<void> connectToMatch({
    required String matchId,
    required bool isHost,
  }) async {
    connectionRepository.send(
      WebSocketMessage.matchJoined(
        matchId: matchId,
        isHost: isHost,
      ),
    );
    await connectionRepository.messages.firstWhere((message) {
      return message.messageType == MessageType.matchJoined;
    });
  }

  Future<void> matchMaking(Emitter<FlopState> emit) async {
    emit(state.withNewMessage('🥺 Requesting match connection'));
    await requestMatchConnection();
    emit(state.withNewMessage('🤝 Connection established'));

    final cardIds = cards.map((card) => card.id).toList();
    deckId = await apiClient.gameResource.createDeck(cardIds);
    emit(state.withNewMessage('👋 User hand is: deckId'));

    matchMakerRepository = MatchMakerRepository(
      db: FirebaseFirestore.instance,
    );
    final match = await matchMakerRepository.findMatch(deckId);
    isHost = match.guest == null;

    await connectToMatch(
      matchId: match.id,
      isHost: isHost,
    );

    if (isHost) {
      final newState = state.copyWith(
        messages: ['👀 No match found, waiting for a guest', ...state.messages],
        steps: [...state.steps, FlopStep.matchmaking],
      );
      emit(newState);

      final stream = matchMakerRepository.watchMatch(match.id);

      final newMatch = await stream.firstWhere((match) => match.guest != null);

      matchId = newMatch.id;
      emit(
        newState.copyWith(
          messages: ['🎉 Match joined', ...newState.messages],
          steps: [...newState.steps, FlopStep.joinedMatch],
        ),
      );
    } else {
      matchId = match.id;
      emit(
        state.copyWith(
          messages: ['🎉 Match joined', ...state.messages],
          steps: [
            ...state.steps,
            FlopStep.matchmaking,
            FlopStep.joinedMatch,
          ],
        ),
      );
    }
  }

  Future<void> playCard(int i, Emitter<FlopState> emit) async {
    await apiClient.gameResource.playCard(
      matchId: matchId,
      cardId: cards[i].id,
      deckId: deckId,
    );
    emit(
      state.withNewMessage(
        '🃏 Played ${cards[i].name}',
      ),
    );
  }

  Future<void> playGame(Emitter<FlopState> emit) async {
    final completer = Completer<void>();
    final matchState = await apiClient.gameResource.getMatchState(matchId);
    matchStateId = matchState!.id;
    late StreamSubscription<MatchState> subscription;

    subscription =
        matchMakerRepository.watchMatchState(matchStateId).listen((matchState) {
      if (matchState.isOver()) {
        emit(
          state.copyWith(
            messages: ['🎉 Match over', ...state.messages],
            steps: [...state.steps, FlopStep.playing],
          ),
        );
        subscription.cancel();
        completer.complete();
      } else {
        final myPlayedCards =
            isHost ? matchState.hostPlayedCards : matchState.guestPlayedCards;
        final opponentPlayedCards =
            isHost ? matchState.guestPlayedCards : matchState.hostPlayedCards;

        if (myPlayedCards.length == opponentPlayedCards.length ||
            myPlayedCards.length < opponentPlayedCards.length) {
          playCard(myPlayedCards.length, emit);
        }
      }
    });
    await playCard(0, emit);
    await completer.future;
  }

  Future<void> _onNextStepRequested(
    _,
    Emitter<FlopState> emit,
  ) async {
    try {
      if (state.steps.isEmpty) {
        await initialize(emit);
        emit(state.copyWith(steps: [FlopStep.initial]));
      } else {
        final lastStep = state.steps.last;
        switch (lastStep) {
          case FlopStep.initial:
            await authenticate(emit);
            emit(
              state.copyWith(
                steps: [...state.steps, FlopStep.authentication],
              ),
            );
            break;
          case FlopStep.authentication:
            await generateCards(emit);
            emit(
              state.copyWith(
                steps: [...state.steps, FlopStep.deckDraft],
              ),
            );
            break;
          case FlopStep.deckDraft:
            await matchMaking(emit);
            break;
          case FlopStep.matchmaking:
            break;
          case FlopStep.joinedMatch:
            await playGame(emit);
            break;
          case FlopStep.playing:
            emit(
              state.copyWith(
                status: FlopStatus.success,
              ),
            );
            break;
        }
      }
    } catch (e, s) {
      emit(
        state.copyWith(
          status: FlopStatus.success,
        ),
      );
      print(e);
      print(s);
      addError(e, s);
      // Do something.
    }
  }
}
