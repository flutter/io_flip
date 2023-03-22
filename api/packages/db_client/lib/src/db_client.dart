import 'package:equatable/equatable.dart';
import 'package:firedart/firedart.dart';

/// {@template db_entity_record}
/// A model representing a record in an entity.
/// {@endtemplate}
class DbEntityRecord extends Equatable {
  /// {@macro db_entity_record}
  const DbEntityRecord({
    required this.id,
    this.data = const {},
  });

  /// Record's  id.
  final String id;

  /// Record's data.
  final Map<String, dynamic> data;

  @override
  List<Object> get props => [id, data];
}

/// {@template db_client}
/// Client used to access the game database
/// {@endtemplate}
class DbClient {
  /// {@macro db_client}
  const DbClient({required Firestore firestore}) : _firestore = firestore;

  /// {@macro db_client}
  ///
  /// This factory returns an already initialized instance of the client.
  factory DbClient.initialize(
    String projectId, {
    bool useEmulator = false,
  }) {
    try {
      Firestore.initialize(
        projectId,
        emulator: useEmulator ? Emulator('127.0.0.1', 8081) : null,
      );
    } on Exception catch (e) {
      if (e.toString() ==
          'Exception: Firestore instance was already initialized') {
        // ignore
      } else {
        rethrow;
      }
    }

    return DbClient(firestore: Firestore.instance);
  }

  final Firestore _firestore;

  /// Adds a new entry to the given [entity], returning the generated id.
  Future<String> add(String entity, Map<String, dynamic> data) async {
    final collection = _firestore.collection(entity);

    final reference = await collection.add(data);

    return reference.id;
  }

  /// Updates a record with the given data.
  Future<void> update(String entity, DbEntityRecord record) async {
    final collection = _firestore.collection(entity);

    final reference = collection.document(record.id);

    await reference.update(record.data);
  }

  /// Creates or updates a record with the given data and document id.
  Future<void> set(String entity, DbEntityRecord record) async {
    final collection = _firestore.collection(entity);

    final reference = collection.document(record.id);

    await reference.set(record.data);
  }

  /// Gets a record by id on the given [entity].
  Future<DbEntityRecord?> getById(String entity, String id) async {
    final collection = _firestore.collection(entity);

    final documentReference = collection.document(id);

    final exists = await documentReference.exists;
    if (!exists) {
      return null;
    }

    final document = await documentReference.get();

    return DbEntityRecord(
      id: document.id,
      data: document.map,
    );
  }

  /// Search for records where the [field] match the [value].
  Future<List<DbEntityRecord>> findBy(
    String entity,
    String field,
    dynamic value,
  ) async {
    final collection = _firestore.collection(entity);

    final results = await collection.where(field, isEqualTo: value).get();

    if (results.isNotEmpty) {
      return results.map((document) {
        return DbEntityRecord(
          id: document.id,
          data: document.map,
        );
      }).toList();
    }

    return [];
  }
}
