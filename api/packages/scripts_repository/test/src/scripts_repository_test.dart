// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scripts_repository/scripts_repository.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('ScriptsRepository', () {
    test('can be instantiated', () {
      expect(
        ScriptsRepository(
          dbClient: _MockDbClient(),
        ),
        isNotNull,
      );
    });
  });
}
