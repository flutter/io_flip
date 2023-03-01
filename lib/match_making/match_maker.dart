import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const _emptyKey = 'EMPTY';

class Match extends Equatable {
  const Match({
    required this.id,
    required this.host,
    required this.lastPing,
    this.guest,
  });

  final String id;
  final String host;
  final String? guest;
  final Timestamp lastPing;

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

/// An error throw when the match making process has timedout.
class MatchMakingTimeout extends Error {}

class MatchMaker {
  MatchMaker({
    required this.db,
    ValueGetter<Timestamp> now = Timestamp.now,
    this.retryDelay = defaultRetryDelay,
  }) : _now = now {
    collection = db.collection('matches');
  }

  static const defaultRetryDelay = 2;
  static const maxRetries = 3;

  final ValueGetter<Timestamp> _now;
  final int retryDelay;
  final FirebaseFirestore db;
  late final CollectionReference<Map<String, dynamic>> collection;

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

  Future<void> pingMatch(String id) async {
    final ref = collection.doc(id);
    await ref.update({'lastPing': _now()});
  }

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

      if (retryNumber == maxRetries) {
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
    return Match(
      id: result.id,
      host: id,
      lastPing: now,
    );
  }
}
