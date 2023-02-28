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
}
