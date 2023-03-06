// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:firedart/firedart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFirestore extends Mock implements Firestore {}

class _MockCollectionRefrence extends Mock implements CollectionReference {}

class _MockDocument extends Mock implements Document {}

class _MockDocumentReference extends Mock implements DocumentReference {}

class _MockQueryReference extends Mock implements QueryReference {}

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

    group('getById', () {
      test('gets an entity in firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionRefrence();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final documentReference = _MockDocumentReference();
        when(() => documentReference.exists).thenAnswer((_) async => true);

        final document = _MockDocument();
        when(() => document.id).thenReturn('id');
        when(() => document.map).thenReturn({'name': 'Dash'});

        when(() => collection.document('id')).thenReturn(documentReference);
        when(documentReference.get).thenAnswer((_) async => document);

        final client = DbClient(firestore: firestore);
        final record = await client.getById('birds', 'id');

        expect(record, isNotNull);
        expect(record!.id, equals('id'));
        expect(record.data['name'], equals('Dash'));
      });

      test("returns null when the entity doesn't exists", () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionRefrence();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final documentReference = _MockDocumentReference();
        when(() => documentReference.exists).thenAnswer((_) async => false);

        when(() => collection.document('id')).thenReturn(documentReference);

        final client = DbClient(firestore: firestore);
        final map = await client.getById('birds', 'id');

        expect(map, isNull);
      });
    });

    group('udpdate', () {
      test('updates and entity ad firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionRefrence();
        final reference = _MockDocumentReference();
        when(() => reference.update(any())).thenAnswer((_) async {});

        when(() => firestore.collection('birds')).thenReturn(collection);
        when(() => collection.document('1')).thenReturn(reference);

        final client = DbClient(firestore: firestore);
        await client.update(
          'birds',
          DbEntityRecord(
            id: '1',
            data: {
              'name': 'Dash',
            },
          ),
        );

        verify(() => reference.update({'name': 'Dash'})).called(1);
      });
    });

    group('findBy', () {
      test('returns the found records', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionRefrence();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.where('type', isEqualTo: 'big'))
            .thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async {
          final record1 = _MockDocument();
          when(() => record1.id).thenReturn('1');
          when(() => record1.map).thenReturn({
            'name': 'dash',
          });
          final record2 = _MockDocument();
          when(() => record2.id).thenReturn('2');
          when(() => record2.map).thenReturn({
            'name': 'furn',
          });

          return [
            record1,
            record2,
          ];
        });

        final client = DbClient(firestore: firestore);

        final result = await client.findBy('birds', 'type', 'big');

        expect(result.first.id, equals('1'));
        expect(result.first.data, equals({'name': 'dash'}));

        expect(result.last.id, equals('2'));
        expect(result.last.data, equals({'name': 'furn'}));
      });

      test('returns empty when no results are returned', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionRefrence();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.where('type', isEqualTo: 'big'))
            .thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async => []);

        final client = DbClient(firestore: firestore);

        final result = await client.findBy('birds', 'type', 'big');
        expect(result, isEmpty);
      });
    });
  });
}
