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
    required this.hostPing,
    this.guestPing,
    this.guest,
    this.inviteCode,
  });

  /// Unique identifier of the match.
  final String id;

  /// Name of the host.
  final String host;

  /// Name of the guest.
  ///
  /// Defaults to `null`.
  final String? guest;

  /// Time when the last ping occurred from the host.
  final Timestamp hostPing;

  /// Time when the last ping occurred from the guest.
  final Timestamp? guestPing;

  /// Code to invite a friend when the match is closed.
  final String? inviteCode;

  /// Returns a new [Match] object with a new [guest] property.
  Match copyWithGuest({
    required String guest,
    required Timestamp guestPing,
  }) {
    return Match(
      id: id,
      host: host,
      guest: guest,
      hostPing: hostPing,
      guestPing: guestPing,
      inviteCode: inviteCode,
    );
  }

  @override
<<<<<<< HEAD
  List<Object?> get props => [id, host, guest, hostPing, guestPing];
=======
  List<Object?> get props => [
        id,
        host,
        guest,
        lastPing,
        inviteCode,
      ];
>>>>>>> 9cce6f4 (feat: adding join private match feature)
}
