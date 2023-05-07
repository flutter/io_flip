// ignore_for_file: subtype_of_sealed_class, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
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

    setUpAll(() {
      registerFallbackValue(Timestamp(0, 0));
    });

    setUp(() {
      db = _MockFirebaseFirestore();
      collection = _MockCollectionReference();
      matchStateCollection = _MockCollectionReference();
      scoreCardsCollection = _MockCollectionReference();

      when(() => db.collection('matches')).thenReturn(collection);
      when(() => db.collection('score_cards')).thenReturn(scoreCardsCollection);
      when(() => db.collection('match_states'))
          .thenReturn(matchStateCollection);
      matchMakerRepository = MatchMakerRepository(
        db: db,
        retryDelay: 0,
        inviteCode: () => 'inviteCode',
      );
    });

    void mockQueryResult({List<DraftMatch> matches = const []}) {
      when(() => collection.where('guest', isEqualTo: 'EMPTY'))
          .thenReturn(collection);
      when(
        () => collection.where(
          'hostConnected',
          isEqualTo: true,
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
        });
        docs.add(doc);
      }

      when(() => query.docs).thenReturn(docs);
      when(collection.get).thenAnswer((_) async => query);
    }

    void mockInviteQueryResult(
      String inviteCode, {
      List<DraftMatch> matches = const [],
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
      String id, {
      String? inviteCode,
    }) {
      when(
        () => collection.add(
          {
            'host': host,
            'guest': guest,
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
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      final transaction = _MockTransaction();
      when(
        () => transaction.update(
          docRef,
          {'guest': guestId},
        ),
      ).thenReturn(transaction);

      final document = _MockDocumentSnapshot<Map<String, dynamic>>();
      when(document.data).thenReturn(<String, dynamic>{
        'host': 'host',
        'guest': 'EMPTY',
      });

      when(() => transaction.get(docRef)).thenAnswer((_) async => document);

      db.mockTransaction = transaction;
    }

    void mockRaceConditionErrorTransaction(
      String guestId,
      String matchId,
    ) {
      final docRef = _MockDocumentReference<Map<String, dynamic>>();
      when(() => collection.doc(matchId)).thenReturn(docRef);

      final transaction = _MockTransaction();
      when(
        () => transaction.update(
          docRef,
          {'guest': guestId},
        ),
      ).thenReturn(transaction);

      final document = _MockDocumentSnapshot<Map<String, dynamic>>();
      when(document.data).thenReturn(<String, dynamic>{
        'host': 'host',
        'guest': 'some_other_id',
      });

      when(() => transaction.get(docRef)).thenAnswer((_) async => document);

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
      mockAdd('hostId', 'EMPTY', 'matchId');
      mockAddState('matchId', const [], const []);

      final match = await matchMakerRepository.findMatch('hostId');
      expect(
        match,
        equals(
          DraftMatch(
            id: 'matchId',
            host: 'hostId',
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
      mockAdd('hostId', 'INVITE', 'matchId', inviteCode: 'inviteCode');
      mockAddState('matchId', const [], const []);

      final match = await matchMakerRepository.createPrivateMatch('hostId');
      expect(
        match,
        equals(
          DraftMatch(
            id: 'matchId',
            host: 'hostId',
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
          DraftMatch(
            id: 'matchId',
            host: 'hostId',
            inviteCode: 'inviteCode',
          ),
        ],
      );
      mockSuccessfulTransaction('guestId', 'matchId');

      final match = await matchMakerRepository.joinPrivateMatch(
        inviteCode: 'inviteCode',
        guestId: 'guestId',
      );
      expect(
        match,
        equals(
          DraftMatch(
            id: 'matchId',
            host: 'hostId',
            guest: 'guestId',
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
            DraftMatch(
              id: 'match123',
              host: 'host123',
            ),
          ],
        );
        mockSuccessfulTransaction('guest123', 'match123');

        final match = await matchMakerRepository.findMatch('guest123');
        expect(
          match,
          equals(
            DraftMatch(
              id: 'match123',
              host: 'host123',
              guest: 'guest123',
            ),
          ),
        );
      },
    );

    test(
      'fails when a race condition happens',
      () async {
        mockQueryResult(
          matches: [
            DraftMatch(
              id: 'match123',
              host: 'host123',
            ),
          ],
        );
        mockRaceConditionErrorTransaction('guest123', 'match123');

        await expectLater(
          () => matchMakerRepository.findMatch('guest123'),
          throwsA(isA<MatchMakingTimeout>()),
        );
      },
    );

    test(
      'throws MatchMakingTimeout when max retry reach its maximum',
      () async {
        mockQueryResult(
          matches: [
            DraftMatch(
              id: 'match123',
              host: 'host123',
            ),
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

      final values = <DraftMatch>[];
      final subscription =
          matchMakerRepository.watchMatch('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'host': 'host1',
        'guest': 'guest1',
        'hostConnected': true,
        'guestConnected': true,
      });

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          DraftMatch(
            id: '123',
            host: 'host1',
            guest: 'guest1',
            hostConnected: true,
            guestConnected: true,
          )
        ]),
      );

      await subscription.cancel();
    });

    test('correctly maps a match when the spot is vacant', () async {
      final streamController =
          StreamController<DocumentSnapshot<Map<String, dynamic>>>();

      mockSnapshots('123', streamController.stream);

      final values = <DraftMatch>[];
      final subscription =
          matchMakerRepository.watchMatch('123').listen(values.add);

      final snapshot = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('123');
      when(snapshot.data).thenReturn({
        'host': 'host1',
        'guest': 'EMPTY',
      });

      streamController.add(snapshot);

      await Future.microtask(() {});

      expect(
        values,
        equals([
          DraftMatch(
            id: '123',
            host: 'host1',
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
