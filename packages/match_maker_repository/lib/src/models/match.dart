import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template match}
/// A class representing a match between a host and a guest.
/// {@endtemplate}
class Match extends Equatable {
  /// {@macro math}
  const Match({
    required this.id,
    required this.host,
    required this.lastPing,
    this.guest,
  });

  /// Unique identifier of the match.
  final String id;

  /// Name of the host.
  final String host;

  /// Name of the guest.
  ///
  /// Defaults to `null`.
  final String? guest;

  /// Time when the last ping occurred.
  final Timestamp lastPing;

  /// Returns a new [Match] object with a new [guest] property.
  Match copyWithGuest({
    required String guest,
  }) {
    return Match(
      id: id,
      host: host,
      guest: guest,
      lastPing: lastPing,
    );
  }

  @override
  List<Object?> get props => [id, host, guest, lastPing];
}
