import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class _MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class _MockFirebaseUser extends Mock implements fb.User {}

class _MockUserCredential extends Mock implements fb.UserCredential {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthenticationRepository', () {
    const userId = 'mock-userId';

    late fb.FirebaseAuth firebaseAuth;
    late fb.UserCredential userCredential;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      const options = FirebaseOptions(
        apiKey: 'apiKey',
        appId: 'appId',
        messagingSenderId: 'messagingSenderId',
        projectId: 'projectId',
      );
      final platformApp = FirebaseAppPlatform(defaultFirebaseAppName, options);
      final firebaseCore = _MockFirebaseCore();

      when(() => firebaseCore.apps).thenReturn([platformApp]);
      when(firebaseCore.app).thenReturn(platformApp);
      when(
        () => firebaseCore.initializeApp(
          name: defaultFirebaseAppName,
          options: options,
        ),
      ).thenAnswer((_) async => platformApp);

      Firebase.delegatePackingProperty = firebaseCore;

      firebaseAuth = _MockFirebaseAuth();
      userCredential = _MockUserCredential();
      authenticationRepository = AuthenticationRepository(
        firebaseAuth: firebaseAuth,
      );
    });

    test('can be instantiated', () {
      expect(AuthenticationRepository(), isNotNull);
    });

    group('user', () {
      test('emits User.unauthenticated when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges()).thenAnswer(
          (_) => Stream.value(null),
        );
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[User.unauthenticated]),
        );
      });

      test('emits returning user when firebase user is not null', () async {
        final firebaseUser = _MockFirebaseUser();
        when(() => firebaseUser.uid).thenReturn(userId);
        when(() => firebaseAuth.authStateChanges()).thenAnswer(
          (_) => Stream.value(firebaseUser),
        );

        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[User(id: userId)]),
        );
      });
    });

    group('idToken', () {
      test('returns stream of idTokens from FirebaseAuth', () async {
        final user1 = _MockFirebaseUser();
        final user2 = _MockFirebaseUser();
        when(user1.getIdToken).thenAnswer((_) async => 'token1');
        when(user2.getIdToken).thenAnswer((_) async => 'token2');
        when(() => firebaseAuth.idTokenChanges()).thenAnswer(
          (_) => Stream.fromIterable([user1, null, user2]),
        );
        await expectLater(
          authenticationRepository.idToken,
          emitsInOrder(['token1', null, 'token2']),
        );

        verify(user1.getIdToken).called(1);
        verify(user2.getIdToken).called(1);
      });
    });

    group('refreshIdToken', () {
      test('calls getIdToken on firebase user', () async {
        final user = _MockFirebaseUser();
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => user.getIdToken(true)).thenAnswer((_) async => 'token');

        final result = await authenticationRepository.refreshIdToken();

        expect(result, 'token');
        verify(() => user.getIdToken(true)).called(1);
      });
    });

    group('signInAnonymously', () {
      test('calls signInAnonymously on FirebaseAuth', () async {
        when(() => firebaseAuth.signInAnonymously()).thenAnswer(
          (_) async => userCredential,
        );

        await authenticationRepository.signInAnonymously();
        verify(() => firebaseAuth.signInAnonymously()).called(1);
      });

      test('throws AuthenticationException on failure', () async {
        when(() => firebaseAuth.signInAnonymously()).thenThrow(
          Exception('oops!'),
        );

        expect(
          () => authenticationRepository.signInAnonymously(),
          throwsA(isA<AuthenticationException>()),
        );
      });
    });

    group('dispose', () {
      test('cancels internal subscriptions', () async {
        final controller = StreamController<fb.User>();
        final emittedUsers = <User>[];
        final firebaseUser = _MockFirebaseUser();

        when(() => firebaseUser.uid).thenReturn(userId);
        when(() => firebaseAuth.authStateChanges()).thenAnswer(
          (_) => controller.stream,
        );

        final subscription = authenticationRepository.user.listen(
          emittedUsers.add,
        );
        authenticationRepository.dispose();

        controller.add(firebaseUser);
        await Future<void>.delayed(Duration.zero);

        expect(emittedUsers, isEmpty);

        await subscription.cancel();
      });
    });
  });
}
