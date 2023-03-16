// ignore_for_file: subtype_of_sealed_class, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' hide Match;
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

class _MockDocumentSnapshot<T> extends Mock implements DocumentSnapshot<T> {}

class _MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class _MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

class _MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

class _MockTransaction extends Mock implements Transaction {}

void main() {
  group('MatchMakerRepository', () {
    late _MockFirebaseFirestore db;
    late CollectionReference<Map<String, dynamic>> collection;
    late CollectionReference<Map<String, dynamic>> matchStateCollection;
    late CollectionReference<Map<String, dynamic>> scoreCardsCollection;
    late MatchMakerRepository matchMakerRepository;
    late Timestamp now;

    setUpAll(() {
      registerFallbackValue(Timestamp(0, 0));
    });

    setUp(() {
      db = _MockFirebaseFirestore();
      collection = _MockCollectionReference();
      matchStateCollection = _MockCollectionReference();
      scoreCardsCollection = _MockCollectionReference();
      now = Timestamp.now();

      when(() => db.collection('matches')).thenReturn(collection);
      when(() => db.collection('match_states'))
          .thenReturn(matchStateCollection);
      matchMakerRepository = MatchMakerRepository(
        db: db,
        retryDelay: 0,
        now: () => now,
        inviteCode: () => 'inviteCode',
      );
    });

    void mockQueryResult({List<Match> matches = const []}) {
      when(() => collection.where('guest', isEqualTo: 'EMPTY'))
          .thenReturn(collection);
      when(
        () => collection.where(
          'hostPing',
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
          'hostPing': match.hostPing,
        });
        docs.add(doc);
      }

      when(() => query.docs).thenReturn(docs);
      when(collection.get).thenAnswer((_) async => query);
    }

    void mockInviteQueryResult(
      String inviteCode, {
      List<Match> matches = const [],
    }) {
      when(() => collection.where('guest', isEqualTo: 'INVITE'))
          .thenReturn(collection);
      when(
        () => collection.where(
          'inviteCode',
          isEqualTo: inviteCode,
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
          'guest': match.guest == null ? 'INVITE' : '',
          'hostPing': match.hostPing,
          'inviteCode': match.inviteCode,
        });
        docs.add(doc);
      }

      when(() => query.docs).thenReturn(docs);
      when(collection.get).thenAnswer((_) async => query);
    }

    void mockAdd(
      String host,
      String guest,
      String id,
      Timestamp ping, {
      String? inviteCode,
    }) {
      when(
        () => collection.add(
          {
            'host': host,
            'guest': guest,
            'hostPing': ping,
            if (inviteCode != null) 'inviteCode': inviteCode,
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

    void mockAddState(
      String matchId,
      List<String> hostPlayedCards,
      List<String> guestPlayedCards,
    ) {
      when(
        () => matchStateCollection.add(
          {
            'matchId': matchId,
            'hostPlayedCards': hostPlayedCards,
            'guestPlayedCards': guestPlayedCards,
          },
        ),
      ).thenAnswer(
        (_) async {
          final docRef = _MockDocumentReference<Map<String, dynamic>>();

          when(() => docRef.id).thenReturn('state_of_$matchId');

          return docRef;
        },
      );
    }

    void mockSuccessfulTransaction(
      String guestId,
      String matchId,
      Timestamp guestPing,
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      final transaction = _MockTransaction();
      when(
        () => transaction.update(
          docRef,
          {'guest': guestId, 'guestPing': guestPing},
        ),
      ).thenReturn(transaction);

      db.mockTransaction = transaction;
    }

    void mockPrivateMatchSuccessfulTransaction(
      String guestId,
      String matchId,
      Timestamp ping,
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      final transaction = _MockTransaction();
      when(
        () => transaction.update(
          docRef,
          {
            'guest': guestId,
            'guestPing': ping,
            'hostPing': ping,
          },
        ),
      ).thenReturn(transaction);

      db.mockTransaction = transaction;
    }

    void mockSnapshots(
      String matchId,
      Stream<DocumentSnapshot<Map<String, dynamic>>> stream,
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      when(docRef.snapshots).thenAnswer((_) => stream);
    }

    void mockMatchStateSnapshots(
      String matchStateId,
      Stream<DocumentSnapshot<Map<String, dynamic>>> stream,
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => matchStateCollection.doc(matchStateId)).thenReturn(docRef);

      when(docRef.snapshots).thenAnswer((_) => stream);
    }

    test('can be instantiated', () {
      expect(
        MatchMakerRepository(db: db),
        isNotNull,
      );
    });

    test('can generate an invite code', () {
      expect(
        MatchMakerRepository.defaultInviteCodeGenerator(),
        isA<String>(),
      );
    });

    test('returns a new match as host when there are no matches', () async {
      mockQueryResult();
      mockAdd('hostId', 'EMPTY', 'matchId', now);
      mockAddState('matchId', const [], const []);

      final match = await matchMakerRepository.findMatch('hostId');
      expect(
        match,
        equals(
          Match(
            id: 'matchId',
            host: 'hostId',
            hostPing: now,
          ),
        ),
      );

      verify(
        () => matchStateCollection.add(
          {
            'matchId': 'matchId',
            'hostPlayedCards': const <String>[],
            'guestPlayedCards': const <String>[],
          },
        ),
      ).called(1);
    });

    test('creates a new match as host when creating a private match', () async {
      mockQueryResult();
      mockAdd('hostId', 'INVITE', 'matchId', now, inviteCode: 'inviteCode');
      mockAddState('matchId', const [], const []);

      final match = await matchMakerRepository.createPrivateMatch('hostId');
      expect(
        match,
        equals(
          Match(
            id: 'matchId',
            host: 'hostId',
            hostPing: now,
            inviteCode: 'inviteCode',
          ),
        ),
      );

      verify(
        () => matchStateCollection.add(
          {
            'matchId': 'matchId',
            'hostPlayedCards': const <String>[],
            'guestPlayedCards': const <String>[],
          },
        ),
      ).called(1);
    });

    test('joins a private match', () async {
      mockInviteQueryResult(
        'inviteCode',
        matches: [
          Match(
            id: 'matchId',
            host: 'hostId',
            inviteCode: 'inviteCode',
            hostPing: now,
          ),
        ],
      );
      mockPrivateMatchSuccessfulTransaction('guestId', 'matchId', now);

      final match = await matchMakerRepository.joinPrivateMatch(
        inviteCode: 'inviteCode',
        guestId: 'guestId',
      );
      expect(
        match,
        equals(
          Match(
            id: 'matchId',
            host: 'hostId',
            guest: 'guestId',
            hostPing: now,
            guestPing: now,
            inviteCode: 'inviteCode',
          ),
        ),
      );
    });

    test(
      'joins a match when one is available and no concurrence error happens',
      () async {
        mockQueryResult(
          matches: [
            Match(id: 'match123', host: 'host123', hostPing: now),
          ],
        );
        mockSuccessfulTransaction('guest123', 'match123', now);

        final match = await matchMakerRepository.findMatch('guest123');
        expect(
          match,
          equals(
            Match(
              id: 'match123',
              host: 'host123',
              guest: 'guest123',
              hostPing: now,
              guestPing: now,
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
            Match(id: 'match123', host: 'host123', hostPing: now),
          ],
        );
        // The mock default behavior is to fail the transaction. So no need
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

      mockSnapshots('123', streamController.stream);

      final values = <Match>[];
      final subscription =
          matchMakerRepository.watchMatch('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'host': 'host1',
        'guest': 'guest1',
        'hostPing': now,
        'guestPing': now,
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
            hostPing: now,
            guestPing: now,
          )
        ]),
      );

      await subscription.cancel();
    });

    test('correctly maps a match when the spot is vacant', () async {
      final streamController =
          StreamController<DocumentSnapshot<Map<String, dynamic>>>();

      mockSnapshots('123', streamController.stream);

      final values = <Match>[];
      final subscription =
          matchMakerRepository.watchMatch('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'host': 'host1',
        'guest': 'EMPTY',
        'hostPing': now,
      });

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          Match(
            id: '123',
            host: 'host1',
            hostPing: now,
          )
        ]),
      );

      await subscription.cancel();
    });

    test('can watch match states', () async {
      final streamController =
          StreamController<DocumentSnapshot<Map<String, dynamic>>>();

      mockMatchStateSnapshots('123', streamController.stream);

      final values = <MatchState>[];
      final subscription =
          matchMakerRepository.watchMatchState('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'matchId': '1234',
        'guestPlayedCards': ['321'],
        'hostPlayedCards': ['322'],
        'result': 'host',
      });

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          MatchState(
            id: '123',
            matchId: '1234',
            guestPlayedCards: const ['321'],
            hostPlayedCards: const ['322'],
            result: MatchResult.host,
          )
        ]),
      );

      await subscription.cancel();
    });

    test('can update the match hostPing', () async {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc('hostId')).thenReturn(docRef);
      when(
        () => docRef.update(
          {'hostPing': now},
        ),
      ).thenAnswer((_) async {});

      await matchMakerRepository.pingHost('hostId');

      verify(
        () => docRef.update(
          {'hostPing': now},
        ),
      ).called(1);
    });

    test('can update the match guestPing', () async {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc('guestId')).thenReturn(docRef);
      when(
        () => docRef.update(
          {'guestPing': now},
        ),
      ).thenAnswer((_) async {});

      await matchMakerRepository.pingGuest('guestId');

      verify(
        () => docRef.update(
          {'guestPing': now},
        ),
      ).called(1);
    });

    test('can get a ScoreCard', () async {
      final ref = _MockDocumentReference<Map<String, dynamic>>();
      final doc = _MockDocumentSnapshot<Map<String, dynamic>>();
      when(() => scoreCardsCollection.doc('id')).thenReturn(ref);
      when(ref.get).thenAnswer((invocation) async => doc);
      when(() => doc.exists).thenReturn(true);
      when(doc.data).thenReturn({
        'wins': 1,
        'currentStreak': 1,
        'longestStreak': 1,
      });
      final result = await matchMakerRepository.getScoreCard('id');
      expect(
        result,
        ScoreCard(
          id: 'id',
          wins: 1,
          currentStreak: 1,
          longestStreak: 1,
        ),
      );
    });

    test('can watch a ScoreCard', () async {
      final streamController =
          StreamController<DocumentSnapshot<Map<String, dynamic>>>();

      final snapshot = _MockDocumentSnapshot<Map<String, dynamic>>();
      final ref = _MockDocumentReference<Map<String, dynamic>>();

      when(() => scoreCardsCollection.doc(any())).thenReturn(ref);
      when(ref.snapshots).thenAnswer((_) => streamController.stream);
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'wins': 1,
        'currentStreak': 1,
        'longestStreak': 1,
      });

      final values = <ScoreCard>[];
      final subscription =
          matchMakerRepository.watchScoreCard('123').listen(values.add);

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          ScoreCard(
            id: '123',
            wins: 1,
            currentStreak: 1,
            longestStreak: 1,
          )
        ]),
      );

      await subscription.cancel();
    });

    test('creates a ScoreCard when one does not exist', () async {
      final ref = _MockDocumentReference<Map<String, dynamic>>();
      final doc = _MockDocumentSnapshot<Map<String, dynamic>>();
      when(() => scoreCardsCollection.doc('id')).thenReturn(ref);
      when(ref.get).thenAnswer((_) async => doc);
      when(() => doc.exists).thenReturn(false);
      when(doc.data).thenReturn(null);
      when(() => ref.set(any())).thenAnswer((_) async {});
      final result = await matchMakerRepository.getScoreCard('id');
      verify(
        () => ref.set({
          'wins': 0,
          'currentStreak': 0,
          'longestStreak': 0,
        }),
      ).called(1);
      expect(
        result,
        ScoreCard(
          id: 'id',
        ),
      );
    });
  });
}
