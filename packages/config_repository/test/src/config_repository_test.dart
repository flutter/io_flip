// ignore_for_file: subtype_of_sealed_class, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:config_repository/config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class _MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

class _MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class _MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

void main() {
  group('ConfigRepository', () {
    late _MockFirebaseFirestore db;
    late CollectionReference<Map<String, dynamic>> collection;
    late ConfigRepository configRepository;

    setUp(() {
      db = _MockFirebaseFirestore();
      collection = _MockCollectionReference();

      when(() => db.collection('config')).thenReturn(collection);

      configRepository = ConfigRepository(
        db: db,
      );
    });

    void mockQueryResult(dynamic value) {
      final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      final query = _MockQuerySnapshot<Map<String, dynamic>>();
      when(
        () => collection.where(
          'type',
          isEqualTo: 'private_match_time_limit',
        ),
      ).thenReturn(collection);
      when(
        () => collection.where(
          'type',
          isEqualTo: 'match_wait_time_limit',
        ),
      ).thenReturn(collection);
      when(
        () => collection.where(
          'type',
          isEqualTo: 'cpu_auto_match_percentage',
        ),
      ).thenReturn(collection);

      when(collection.get).thenAnswer((_) async => query);
      when(() => query.docs).thenReturn([doc]);
      when(doc.data).thenReturn({'value': value});
    }

    test('can be instantiated', () {
      expect(
        ConfigRepository(db: db),
        isNotNull,
      );
    });
    group('getPrivateMatchTimeLimit', () {
      test('returns time limit from firebase config', () async {
        mockQueryResult(0);
        await expectLater(
          await configRepository.getPrivateMatchTimeLimit(),
          equals(0),
        );
      });

      test('returns default time limit when none exists on firebase', () async {
        when(
          () => collection.where(
            'type',
            isEqualTo: 'private_match_time_limit',
          ),
        ).thenThrow(Exception('oops'));
        await expectLater(
          await configRepository.getPrivateMatchTimeLimit(),
          equals(configRepository.defaultPrivateTimeLimit),
        );
      });
    });

    group('getMatchWaitTimeLimit', () {
      test('returns time limit from firebase config', () async {
        mockQueryResult(0);
        await expectLater(
          await configRepository.getMatchWaitTimeLimit(),
          equals(0),
        );
      });

      test('returns default time limit when none exists on firebase', () async {
        when(
          () => collection.where(
            'type',
            isEqualTo: 'match_wait_time_limit',
          ),
        ).thenThrow(Exception('oops'));
        await expectLater(
          await configRepository.getMatchWaitTimeLimit(),
          equals(configRepository.defaultMatchWaitTimeLimit),
        );
      });

      group('getMatchWaitTimeLimit', () {
        test('returns time limit from firebase config', () async {
          mockQueryResult(0.0);
          await expectLater(
            await configRepository.getCPUAutoMatchPercentage(),
            equals(0.0),
          );
        });

        test('returns default time limit when none exists on firebase',
            () async {
          when(
            () => collection.where(
              'type',
              isEqualTo: 'cpu_auto_match_percentage',
            ),
          ).thenThrow(Exception('oops'));
          await expectLater(
            await configRepository.getCPUAutoMatchPercentage(),
            equals(configRepository.defaultCPUAutoMatchPercentage),
          );
        });
      });
    });
  });
}
