import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template match}
/// A class representing a match between a host and a guest.
/// {@endtemplate}
class Match extends Equatable {
  /// {@macro match}
  const Match({
    required this.id,
    required this.host,
    this.guest,
    this.inviteCode,
    this.guestConnected = false,
    this.hostConnected = false,
  });

  /// Unique identifier of the match.
  final String id;

  /// Name of the host.
  final String host;

  /// Name of the guest.
  ///
  /// Defaults to `null`.
  final String? guest;

  /// Code to invite a friend when the match is closed.
  final String? inviteCode;

  /// If the host is connected or disconnected from the match.
  final bool hostConnected;

  /// If the guest is connected or disconnected from the match.
  final bool guestConnected;

  /// Returns a new [Match] object with a new [guest] property.
  Match copyWithGuest({
    required String guest,
  }) {
    return Match(
      id: id,
      host: host,
      guest: guest,
      inviteCode: inviteCode,
    );
  }

  @override
  List<Object?> get props => [
        id,
        host,
        hostConnected,
        guest,
        guestConnected,
        inviteCode,
      ];
}
