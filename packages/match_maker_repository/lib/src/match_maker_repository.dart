import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
      final lastPing = data['lastPing'] as Timestamp;

      return Match(
        id: id,
        host: host,
        guest: guest == _emptyKey ? null : guest,
        lastPing: lastPing,
      );
    });
  }

  /// Watch for the host played cards in a match state.
  Stream<String> watchHostCards(String matchStateId) {
    return matchStatesCollection.doc(matchStateId).snapshots().map((snapshot) {
      final data = snapshot.data()!;
      final hostCards = (data['hostPlayedCards'] as List).cast<String>();

      return hostCards.last;
    });
  }

  /// Watch for the host played cards in a match state.
  Stream<String> watchGuestCards(String matchStateId) {
    return matchStatesCollection.doc(matchStateId).snapshots().map((snapshot) {
      final data = snapshot.data()!;
      final guestCards = (data['guestPlayedCards'] as List).cast<String>();

      return guestCards.last;
    });
  }

  /// Pings a match.
  Future<void> pingMatch(String id) async {
    //final ref = collection.doc(id);
    //await ref.update({'lastPing': _now()});
  }

  /// Finds a match.
  Future<Match> findMatch(String id, {int retryNumber = 0}) async {
    final matchesResult = await collection
        .where(
          'guest',
          isEqualTo: _emptyKey,
        )
        .where(
          'lastPing',
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
        final lastPing = data['lastPing'] as Timestamp;

        return Match(id: id, host: host, lastPing: lastPing);
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
      'lastPing': now,
    });
    await matchStatesCollection.add({
      'matchId': result.id,
      'hostPlayedCards': const <String>[],
      'guestPlayedCards': const <String>[],
    });
    return Match(
      id: result.id,
      host: id,
      lastPing: now,
    );
  }
}
