import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart' hide Match;
import 'package:match_maker_repository/match_maker_repository.dart';

const _emptyKey = 'EMPTY';

/// Represents an error that occurs when a matchmaking process times out.
class MatchMakingTimeout extends Error {}

/// {@template match_maker_repository}
/// Repository for match making.
/// {@endtemplate}
class MatchMakerRepository {
  /// {@macro match_maker_repository}
  MatchMakerRepository({
    required this.db,
    ValueGetter<Timestamp> now = Timestamp.now,
    this.retryDelay = _defaultRetryDelay,
  }) : _now = now {
    collection = db.collection('matches');
    matchStatesCollection = db.collection('match_states');
  }

  static const _defaultRetryDelay = 2;
  static const _maxRetries = 3;

  final ValueGetter<Timestamp> _now;

  /// The delay between retries when finding a match.
  final int retryDelay;

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore db;

  /// The [CollectionReference] for the matches.
  late final CollectionReference<Map<String, dynamic>> collection;

  /// The [CollectionReference] for the match_states.
  late final CollectionReference<Map<String, dynamic>> matchStatesCollection;

  /// Watches a match.
  Stream<Match> watchMatch(String id) {
    return collection.doc(id).snapshots().map((snapshot) {
      final id = snapshot.id;
      final data = snapshot.data()!;
      final host = data['host'] as String;
      final guest = data['guest'] as String;
      final hostPing = data['hostPing'] as Timestamp;
      final guestPing = data['guestPing'] as Timestamp;

      return Match(
        id: id,
        host: host,
        guest: guest == _emptyKey ? null : guest,
        hostPing: hostPing,
        guestPing: guestPing,
      );
    });
  }

  /// Watches a match state.
  Stream<MatchState> watchMatchState(String id) {
    return matchStatesCollection.doc(id).snapshots().map((snapshot) {
      final id = snapshot.id;
      final data = snapshot.data()!;
      final matchId = data['matchId'] as String;
      final hostCards = (data['hostPlayedCards'] as List).cast<String>();
      final guestCards = (data['guestPlayedCards'] as List).cast<String>();
      final result = MatchResult.valueOf(data['result'] as String?);

      return MatchState(
        id: id,
        matchId: matchId,
        hostPlayedCards: hostCards,
        guestPlayedCards: guestCards,
        result: result,
      );
    });
  }

  /// Finds a match.
  Future<Match> findMatch(String id, {int retryNumber = 0}) async {
    final matchesResult = await collection
        .where(
          'guest',
          isEqualTo: _emptyKey,
        )
        .where(
          'hostPing',
          isGreaterThanOrEqualTo: Timestamp.fromMillisecondsSinceEpoch(
            _now().millisecondsSinceEpoch - 4000,
          ),
        )
        .limit(3)
        .get();

    if (matchesResult.docs.isEmpty) {
      log('No match available, creating a new one.');
      return _createMatch(id);
    } else {
      final matches = matchesResult.docs.map((element) {
        final id = element.id;
        final data = element.data();
        final host = data['host'] as String;
        final hostPing = data['hostPing'] as Timestamp;
        final guestPing = data['guestPing'] as Timestamp;

        return Match(
          id: id,
          host: host,
          hostPing: hostPing,
          guestPing: guestPing,
        );
      }).toList();

      for (final match in matches) {
        try {
          await db.runTransaction<Transaction>((transaction) async {
            final ref = collection.doc(match.id);
            return transaction.update(ref, {'guest': id});
          });
          return match.copyWithGuest(guest: id);
        } catch (e) {
          log('Match "${match.id}" already matched, trying next...');
        }
      }

      if (retryNumber == _maxRetries) {
        throw MatchMakingTimeout();
      }

      log('No match available, trying again in 2 seconds...');
      return Future.delayed(
        Duration(seconds: retryDelay),
        () => findMatch(id, retryNumber: retryNumber + 1),
      );
    }
  }

  Future<Match> _createMatch(String id) async {
    final now = _now();
    final result = await collection.add({
      'host': id,
      'guest': _emptyKey,
      'hostPing': now,
      'guestPing': now,
    });
    await matchStatesCollection.add({
      'matchId': result.id,
      'hostPlayedCards': const <String>[],
      'guestPlayedCards': const <String>[],
    });
    return Match(
      id: result.id,
      host: id,
      hostPing: now,
      guestPing: now,
    );
  }
}
