import 'package:firedart/firedart.dart';

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
  Future<Map<String, dynamic>?> getById(String entity, String id) async {
    final collection = _firestore.collection(entity);

    final documentReference = collection.document(id);

    final exists = await documentReference.exists;
    if (!exists) {
      return null;
    }

    final document = await documentReference.get();

    return {
      id: document.id,
      ...document.map,
    };
  }
}
