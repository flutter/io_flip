import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/connection/connection.dart';

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

void main() {
  group('ConnectionBloc', () {
    late ConnectionRepository connectionRepository;
    late StreamController<WebSocketMessage> messageController;

    setUp(() {
      connectionRepository = _MockConnectionRepository();
      messageController = StreamController<WebSocketMessage>();
      when(() => connectionRepository.messages)
          .thenAnswer((_) => messageController.stream);
    });

    group('on ConnectionRequested', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInProgress when connection is successful',
        setUp: () {
          when(() => connectionRepository.connect()).thenAnswer((_) async {});
        },
        build: () => ConnectionBloc(connectionRepository: connectionRepository),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        expect: () => [
          const ConnectionInProgress(),
        ],
        verify: (_) {
          verify(() => connectionRepository.connect()).called(1);
          verify(() => connectionRepository.messages).called(1);
        },
      );
      blocTest<ConnectionBloc, ConnectionState>(
        'emits [ConnectionInProgress, ConnectionSuccessful] when connection is '
        'successful and a connected message is received',
        setUp: () {
          when(() => connectionRepository.connect()).thenAnswer((_) async {});
          messageController.onListen = () {
            messageController.add(const WebSocketMessage.connected());
          };
        },
        build: () => ConnectionBloc(connectionRepository: connectionRepository),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        expect: () => [
          const ConnectionInProgress(),
          const ConnectionSuccess(),
        ],
        verify: (_) {
          verify(() => connectionRepository.connect()).called(1);
          verify(() => connectionRepository.messages).called(1);
        },
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits [ConnectionInProgress, ConnectionFailure] when connection is '
        'successful and an error message is received',
        setUp: () {
          when(() => connectionRepository.connect()).thenAnswer((_) async {});
          messageController.onListen = () {
            messageController.add(
              WebSocketMessage.error(WebSocketErrorCode.playerAlreadyConnected),
            );
          };
        },
        build: () => ConnectionBloc(connectionRepository: connectionRepository),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        expect: () => [
          const ConnectionInProgress(),
          const ConnectionFailure(WebSocketErrorCode.playerAlreadyConnected),
        ],
        verify: (_) {
          verify(() => connectionRepository.connect()).called(1);
          verify(() => connectionRepository.messages).called(1);
        },
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial when messages stream is closed',
        setUp: () {
          when(() => connectionRepository.connect()).thenAnswer((_) async {});
          messageController.onListen = () {
            messageController.close();
          };
        },
        build: () => ConnectionBloc(connectionRepository: connectionRepository),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        expect: () => [
          const ConnectionInProgress(),
          const ConnectionInitial(),
        ],
        verify: (_) {
          verify(() => connectionRepository.connect()).called(1);
          verify(() => connectionRepository.messages).called(1);
        },
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits [ConnectionInProgress, ConnectionFailure] '
        'when connection is not successful',
        setUp: () {
          when(() => connectionRepository.connect()).thenThrow(Exception());
        },
        build: () => ConnectionBloc(connectionRepository: connectionRepository),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        expect: () => [
          const ConnectionInProgress(),
          const ConnectionFailure(WebSocketErrorCode.unknown),
        ],
        verify: (_) {
          verify(() => connectionRepository.connect()).called(1);
        },
        errors: () => [
          isA<Exception>(),
        ],
      );
    });
  });
}
