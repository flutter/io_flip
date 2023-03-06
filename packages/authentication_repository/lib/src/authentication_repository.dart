import 'package:firebase_auth/firebase_auth.dart';

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
  AuthenticationRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  /// Sign in the user anonymously.
  ///
  /// If the sign in fails, an [AuthenticationException] is thrown.
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on Exception catch (error, stackTrace) {
      throw AuthenticationException(error, stackTrace);
    }
  }
}
