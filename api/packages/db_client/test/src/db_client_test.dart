// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:firedart/firedart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFirestore extends Mock implements Firestore {}

class _MockCollectionRefrence extends Mock implements CollectionReference {}

class _MockDocument extends Mock implements Document {}

void main() {
  group('DbClient', () {
    test('can be instantiated', () {
      expect(DbClient(firestore: _MockFirestore()), isNotNull);
    });

    test('can be initialized', () {
      expect(DbClient.initialize('A'), isNotNull);
    });

    group('add', () {
      test('insert into firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionRefrence();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final document = _MockDocument();
        when(() => document.id).thenReturn('id');

        when(() => collection.add(any())).thenAnswer((_) async => document);

        final client = DbClient(firestore: firestore);
        final id = await client.add('birds', {'name': 'Dash'});

        expect(id, equals('id'));
        verify(() => collection.add({'name': 'Dash'})).called(1);
      });
    });
  });
}
