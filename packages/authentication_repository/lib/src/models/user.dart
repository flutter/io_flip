import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
  });

  /// The current user's id.
  final String id;

  /// Represents an unauthenticated user.
  static const unauthenticated = User(id: '');

  @override
  List<Object?> get props => [id];
}
