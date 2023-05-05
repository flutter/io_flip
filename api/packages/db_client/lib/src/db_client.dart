import 'package:equatable/equatable.dart';
import 'package:firedart/firedart.dart';
import 'package:grpc/grpc.dart';

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
        useApplicationDefaultAuth: true,
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

  static const _maxRetries = 2;

  /// Adds a new entry to the given [entity], returning the generated id.
  Future<String> add(String entity, Map<String, dynamic> data) =>
      _add(entity, data, 0);

  Future<String> _add(
    String entity,
    Map<String, dynamic> data,
    int attempt,
  ) async {
    try {
      final collection = _firestore.collection(entity);

      final reference = await collection.add(data);

      return reference.id;
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _add(entity, data, attempt + 1);
      } else {
        rethrow;
      }
    }
  }

  /// Updates a record with the given data.
  Future<void> update(String entity, DbEntityRecord record) =>
      _update(entity, record, 0);

  Future<void> _update(
    String entity,
    DbEntityRecord record,
    int attempt,
  ) async {
    try {
      final collection = _firestore.collection(entity);

      final reference = collection.document(record.id);

      await reference.update(record.data);
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _update(entity, record, attempt + 1);
      } else {
        rethrow;
      }
    }
  }

  /// Creates or updates a record with the given data and document id.
  Future<void> set(String entity, DbEntityRecord record) =>
      _set(entity, record, 0);

  Future<void> _set(String entity, DbEntityRecord record, int attempt) async {
    try {
      final collection = _firestore.collection(entity);

      final reference = collection.document(record.id);

      await reference.set(record.data);
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _set(entity, record, attempt + 1);
      } else {
        rethrow;
      }
    }
  }

  /// Gets a record by id on the given [entity].
  Future<DbEntityRecord?> getById(String entity, String id) =>
      _getById(entity, id, 0);

  Future<DbEntityRecord?> _getById(
    String entity,
    String id,
    int attempt,
  ) async {
    try {
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
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _getById(entity, id, attempt + 1);
      } else {
        rethrow;
      }
    }
  }

  List<DbEntityRecord> _mapResult(List<Document> results) {
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

  /// Search for records where the [field] match the [value].
  Future<List<DbEntityRecord>> findBy(
    String entity,
    String field,
    dynamic value,
  ) =>
      _findBy(entity, field, value, 0);

  Future<List<DbEntityRecord>> _findBy(
    String entity,
    String field,
    dynamic value,
    int attempt,
  ) async {
    try {
      final collection = _firestore.collection(entity);

      final results = await collection.where(field, isEqualTo: value).get();
      return _mapResult(results);
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _findBy(entity, field, value, attempt + 1);
      } else {
        rethrow;
      }
    }
  }

  /// Search for records where the [where] clause is true.
  ///
  /// The [where] map should contain the field name as key and the value
  /// to compare to.
  Future<List<DbEntityRecord>> find(
    String entity,
    Map<String, dynamic> where,
  ) =>
      _find(entity, where, 0);

  Future<List<DbEntityRecord>> _find(
    String entity,
    Map<String, dynamic> where,
    int attempt,
  ) async {
    try {
      final collection = _firestore.collection(entity);

      var query = collection.where(
        where.keys.first,
        isEqualTo: where.values.first,
      );
      for (var i = 1; i < where.length; i++) {
        query = query.where(
          where.keys.elementAt(i),
          isEqualTo: where.values.elementAt(i),
        );
      }

      final results = await query.get();
      return _mapResult(results);
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _find(entity, where, attempt + 1);
      } else {
        rethrow;
      }
    }
  }

  /// Gets the [limit] records sorted by the specified [field].
  Future<List<DbEntityRecord>> orderBy(
    String entity,
    String field, {
    int limit = 10,
    bool descending = true,
  }) =>
      _orderBy(
        entity,
        field,
        limit: limit,
        descending: descending,
        attempt: 0,
      );

  Future<List<DbEntityRecord>> _orderBy(
    String entity,
    String field, {
    required int attempt,
    int limit = 10,
    bool descending = true,
  }) async {
    try {
      final collection = _firestore.collection(entity);

      final results = await collection
          .orderBy(field, descending: descending)
          .limit(limit)
          .get();

      return results.map((document) {
        return DbEntityRecord(
          id: document.id,
          data: document.map,
        );
      }).toList();
    } on GrpcError catch (_) {
      if (attempt < _maxRetries) {
        return _orderBy(
          entity,
          field,
          limit: limit,
          descending: descending,
          attempt: attempt + 1,
        );
      } else {
        rethrow;
      }
    }
  }
}
