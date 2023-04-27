// ignore_for_file: prefer_const_constructors
import 'package:config_repository/config_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('ConfigRepository', () {
    late DbClient dbClient;
    late ConfigRepository configRepository;

    setUp(() {
      dbClient = _MockDbClient();
      configRepository = ConfigRepository(dbClient: dbClient);
    });

    test('can be instantiated', () {
      expect(
        ConfigRepository(
          dbClient: _MockDbClient(),
        ),
        isNotNull,
      );
    });

    group('getCardVariations', () {
      test('return the value in the db', () async {
        when(() => dbClient.findBy('config', 'type', 'variations')).thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: '1',
              data: const {
                'type': 'variations',
                'value': '10',
              },
            ),
          ],
        );

        expect(await configRepository.getCardVariations(), equals(10));
      });

      test(
        'return the default value when there is no nothing in the db',
        () async {
          when(() => dbClient.findBy('config', 'type', 'variations'))
              .thenAnswer(
            (_) async => [],
          );

          expect(await configRepository.getCardVariations(), equals(8));
        },
      );

      test(
        'return default value when there is an error',
        () async {
          when(() => dbClient.findBy('config', 'type', 'variations'))
              .thenThrow(Exception('error'));

          expect(await configRepository.getCardVariations(), equals(8));
        },
      );
    });
  });
}
