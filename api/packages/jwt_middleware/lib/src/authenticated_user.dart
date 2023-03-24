import 'package:equatable/equatable.dart';

/// {@template authenticated_user}
/// Represents an authenticated user of the api.
/// {@endtemplate}
class AuthenticatedUser extends Equatable {
  /// {@macro authenticated_user}
  const AuthenticatedUser(this.id);

  /// The firebase user id of the user.
  final String id;

  @override
  List<Object?> get props => [id];
}
