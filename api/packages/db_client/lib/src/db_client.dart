import 'package:firedart/firedart.dart';

/// {@template db_entity_record}
/// A model representing a record in an entity.
/// {@endtemplate}
class DbEntityRecord {
  /// {@macro db_entity_record}
  const DbEntityRecord({
    required this.id,
    this.data = const {},
  });

  /// Record's  id.
  final String id;

  /// Record's data.
  final Map<String, dynamic> data;
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
  factory DbClient.initialize(String projectId) {
    Firestore.initialize(projectId);
    return DbClient(firestore: Firestore.instance);
  }

  final Firestore _firestore;

  /// Adds a new entry to the given [entity], returning the generated id.
  Future<String> add(String entity, Map<String, dynamic> data) async {
    final collection = _firestore.collection(entity);

    final reference = await collection.add(data);

    return reference.id;
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
}
