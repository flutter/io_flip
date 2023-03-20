import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

/// {@template authentication_exception}
/// Exception thrown when an authentication process fails.
/// {@endtemplate}
class AuthenticationException implements Exception {
  /// {@macro authentication_exception}
  const AuthenticationException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The stack trace associated with the error.
  final StackTrace stackTrace;
}

/// {@template authentication_repository}
/// Repository to manage authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    fb.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _userController = StreamController<User>.broadcast();

  final fb.FirebaseAuth _firebaseAuth;
  final StreamController<User> _userController;
  StreamSubscription<fb.User?>? _firebaseUserSubscription;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.unauthenticated] if the user is not authenticated.
  Stream<User> get user {
    _firebaseUserSubscription ??=
        _firebaseAuth.authStateChanges().listen((firebaseUser) {
      _userController.add(
        firebaseUser?.toUser ?? User.unauthenticated,
      );
    });

    return _userController.stream;
  }

  /// Stream of id tokens that can be used to authenticate with Firebase.
  Stream<String?> get idToken {
    return _firebaseAuth
        .idTokenChanges()
        .asyncMap((user) => user?.getIdToken());
  }

  /// Refreshes the id token.
  Future<String?> refreshIdToken() async {
    final user = _firebaseAuth.currentUser;
    return user?.getIdToken(true);
  }

  /// Sign in the user anonymously.
  ///
  /// If the sign in fails, an [AuthenticationException] is thrown.
  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      _userController.add(userCredential.toUser);
    } on Exception catch (error, stackTrace) {
      throw AuthenticationException(error, stackTrace);
    }
  }

  /// Disposes any internal resources.
  void dispose() {
    _firebaseUserSubscription?.cancel();
    _userController.close();
  }
}

extension on fb.User {
  User get toUser => User(id: uid);
}

extension on fb.UserCredential {
  User get toUser => user?.toUser ?? User.unauthenticated;
}
