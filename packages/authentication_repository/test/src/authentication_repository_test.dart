import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUserCredential extends Mock implements UserCredential {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthenticationRepository', () {
    late FirebaseAuth firebaseAuth;
    late UserCredential userCredential;
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
  });
}
