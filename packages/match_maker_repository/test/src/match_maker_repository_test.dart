// ignore_for_file: subtype_of_sealed_class, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {
  Transaction? mockTransaction;

  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    if (mockTransaction == null) {
      throw Exception('No mock transaction set');
    }

    final value = await transactionHandler(mockTransaction!);

    mockTransaction = null;

    return value;
  }
}

class _MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

class _MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class _MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

class _MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

class _MockTransaction extends Mock implements Transaction {}

void main() {
  group('MatchMakerRepository', () {
    late _MockFirebaseFirestore db;
    late CollectionReference<Map<String, dynamic>> collection;
    late MatchMakerRepository matchMakerRepository;
    late Timestamp now;

    setUp(() {
      db = _MockFirebaseFirestore();
      collection = _MockCollectionReference();
      now = Timestamp.now();

      when(() => db.collection('matches')).thenReturn(collection);
      matchMakerRepository = MatchMakerRepository(
        db: db,
        retryDelay: 0,
        now: () => now,
      );
    });

    void mockQueryResult({List<Match> matches = const []}) {
      when(() => collection.where('guest', isEqualTo: 'EMPTY'))
          .thenReturn(collection);
      when(
        () => collection.where(
          'lastPing',
          isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo'),
        ),
      ).thenReturn(collection);
      when(() => collection.limit(3)).thenReturn(collection);

      final query = _MockQuerySnapshot<Map<String, dynamic>>();

      final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      for (final match in matches) {
        final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(() => doc.id).thenReturn(match.id);
        when(doc.data).thenReturn({
          'host': match.host,
          'guest': match.guest == null ? 'EMPTY' : '',
          'lastPing': match.lastPing,
        });
        docs.add(doc);
      }

      when(() => query.docs).thenReturn(docs);
      when(collection.get).thenAnswer((_) async => query);
    }

    void mockAdd(String host, String guest, String id, Timestamp lastPing) {
      when(
        () => collection.add(
          {
            'host': host,
            'guest': guest,
            'lastPing': lastPing,
          },
        ),
      ).thenAnswer(
        (_) async {
          final docRef = _MockDocumentReference<Map<String, dynamic>>();

          when(() => docRef.id).thenReturn(id);

          return docRef;
        },
      );
    }

    _MockDocumentReference<Map<String, dynamic>> mockUpdate(String matchId) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);
      when(() => docRef.update(any())).thenAnswer((_) async {});
      return docRef;
    }

    void mockSuccessfulTransaction(String guestId, String matchId) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      final transaction = _MockTransaction();
      when(() => transaction.update(docRef, {'guest': guestId}))
          .thenReturn(transaction);

      db.mockTransaction = transaction;
    }

    void mockSnapshoots(
      String matchId,
      Stream<DocumentSnapshot<Map<String, dynamic>>> stream,
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      when(docRef.snapshots).thenAnswer((_) => stream);
    }

    test('can be instantiated', () {
      expect(
        MatchMakerRepository(db: db),
        isNotNull,
      );
    });

    test('updates the match document on ping', () async {
      final mockDoc = mockUpdate('matchId');

      await matchMakerRepository.pingMatch('matchId');

      verify(
        () => mockDoc.update(
          {
            'lastPing': now,
          },
        ),
      ).called(1);
    });

    test('returns a new match as host when there are no matches', () async {
      mockQueryResult();
      mockAdd('hostId', 'EMPTY', 'matchId', now);

      final match = await matchMakerRepository.findMatch('hostId');
      expect(
        match,
        equals(
          Match(
            id: 'matchId',
            host: 'hostId',
            lastPing: now,
          ),
        ),
      );
    });

    test(
      'joins a match when one is available and no concurrence error happens',
      () async {
        mockQueryResult(
          matches: [
            Match(id: 'match123', host: 'host123', lastPing: now),
          ],
        );
        mockSuccessfulTransaction('guest123', 'match123');

        final match = await matchMakerRepository.findMatch('guest123');
        expect(
          match,
          equals(
            Match(
              id: 'match123',
              host: 'host123',
              guest: 'guest123',
              lastPing: now,
            ),
          ),
        );
      },
    );

    test(
      'joins a match when one is available and no concurrence error happens',
      () async {
        final now = Timestamp.fromMillisecondsSinceEpoch(
          Timestamp.now().millisecondsSinceEpoch - 2000,
        );
        mockQueryResult(
          matches: [
            Match(id: 'match123', host: 'host123', lastPing: now),
          ],
        );
        mockSuccessfulTransaction('guest123', 'match123');

        final match = await matchMakerRepository.findMatch('guest123');
        expect(
          match,
          equals(
            Match(
              id: 'match123',
              host: 'host123',
              guest: 'guest123',
              lastPing: now,
            ),
          ),
        );
      },
    );

    test(
      'throws MatchMakingTimeout when max retry reach its maximum',
      () async {
        mockQueryResult(
          matches: [
            Match(id: 'match123', host: 'host123', lastPing: now),
          ],
        );
        // The mock defaul behavior is to fail the transaction. So no need
        // manually mock a failed transaction.

        await expectLater(
          () => matchMakerRepository.findMatch('guest123'),
          throwsA(isA<MatchMakingTimeout>()),
        );
      },
    );

    test('can watch a match', () async {
      final streamController =
          StreamController<DocumentSnapshot<Map<String, dynamic>>>();

      mockSnapshoots('123', streamController.stream);

      final values = <Match>[];
      final subscription =
          matchMakerRepository.watchMatch('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'host': 'host1',
        'guest': 'guest1',
        'lastPing': now,
      });

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          Match(
            id: '123',
            host: 'host1',
            guest: 'guest1',
            lastPing: now,
          )
        ]),
      );

      await subscription.cancel();
    });

    test('correctly maps a match when the spot is vacant', () async {
      final streamController =
          StreamController<DocumentSnapshot<Map<String, dynamic>>>();

      mockSnapshoots('123', streamController.stream);

      final values = <Match>[];
      final subscription =
          matchMakerRepository.watchMatch('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'host': 'host1',
        'guest': 'EMPTY',
        'lastPing': now,
      });

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          Match(
            id: '123',
            host: 'host1',
            lastPing: now,
          )
        ]),
      );

      await subscription.cancel();
    });
  });
}
