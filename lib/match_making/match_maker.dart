import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

const _emptyKey = 'EMPTY';

class Match extends Equatable {
  const Match({
    required this.id,
    required this.host,
    this.guest,
  });

  final String id;
  final String host;
  final String? guest;

  Match copyWith({
    String? id,
    String? host,
    String? guest,
  }) {
    return Match(
      id: id ?? this.id,
      host: host ?? this.host,
      guest: guest ?? this.guest,
    );
  }

  @override
  List<Object?> get props => [id, host, guest];
}

class MatchMaker {
  MatchMaker({
    required this.db,
  }) {
    collection = db.collection('matches');
  }

  final FirebaseFirestore db;
  late final CollectionReference<Map<String, dynamic>> collection;

  Stream<Match> watchMatch(String id) {
    return collection.doc(id).snapshots().map((snapshot) {
      final id = snapshot.id;
      final data = snapshot.data()!;
      final host = data['host'] as String;
      final guest = data['guest'] as String;

      return Match(
        id: id,
        host: host,
        guest: guest == _emptyKey ? null : guest,
      );
    });
  }

  Future<Match> findMatch(String id) async {
    final matchesResult = await collection
        .where(
          'guest',
          isEqualTo: _emptyKey,
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

        return Match(id: id, host: host);
      }).toList();

      for (final match in matches) {
        try {
          await db.runTransaction((transaction) async {
            final ref = collection.doc(match.id);
            transaction.update(ref, {'guest': id});
          });
          return match.copyWith(guest: id);
        } catch (_) {
          log('Match "${match.id}" already matched, trying next...');
        }
      }

      log('No match available, trying again in 2 seconds...');
      return Future.delayed(
        const Duration(seconds: 2),
        () => findMatch(id),
      );
    }
  }

  Future<Match> _createMatch(String id) async {
    final result = await collection.add({
      'host': id,
      'guest': _emptyKey,
    });
    return Match(
      id: result.id,
      host: id,
    );
  }
}
