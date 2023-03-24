// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scripts_repository/scripts_repository.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('ScriptsRepository', () {
    setUpAll(() {
      registerFallbackValue(
        DbEntityRecord(
          id: '',
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        ScriptsRepository(
          dbClient: _MockDbClient(),
        ),
        isNotNull,
      );
    });

    late DbClient dbClient;
    late ScriptsRepository scriptsRepository;

    void mockQuery(List<DbEntityRecord> result) {
      when(() => dbClient.findBy('scripts', 'selected', true))
          .thenAnswer((_) async => result);
    }

    setUp(() {
      dbClient = _MockDbClient();
      when(() => dbClient.add(any(), any())).thenAnswer((_) async => '');

      when(() => dbClient.update(any(), any())).thenAnswer((_) async => '');

      scriptsRepository = ScriptsRepository(dbClient: dbClient);
    });

    group('getCurrentScript', () {
      test('returns the default when there is none in the db', () async {
        mockQuery([]);

        final script = await scriptsRepository.getCurrentScript();
        expect(script, equals(defaultGameLogic));
      });

      test('returns the db result', () async {
        mockQuery([
          DbEntityRecord(
            id: '',
            data: const {
              'script': 'script',
              'selected': true,
            },
          ),
        ]);

        final script = await scriptsRepository.getCurrentScript();
        expect(script, equals('script'));
      });
    });

    group('updateCurrentScript', () {
      test("creates a new record when there isn't one yet", () async {
        mockQuery([]);

        await scriptsRepository.updateCurrentScript('script');
        verify(
          () => dbClient.add('scripts', {
            'script': 'script',
            'selected': true,
          }),
        ).called(1);
      });

      test('updates the existent when there is one', () async {
        mockQuery([
          DbEntityRecord(
            id: 'id',
            data: const {
              'script': 'script',
              'selected': true,
            },
          ),
        ]);

        await scriptsRepository.updateCurrentScript('script 2');
        verify(
          () => dbClient.update(
            'scripts',
            DbEntityRecord(
              id: 'id',
              data: const {
                'script': 'script 2',
                'selected': true,
              },
            ),
          ),
        ).called(1);
      });
    });
  });
}
