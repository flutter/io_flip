import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _MockPromptResource extends Mock implements PromptResource {}

void main() {
  late PromptResource promptResource;

  setUpAll(() {
    registerFallbackValue(PromptTermType.characterClass);
  });

  setUp(() {
    promptResource = _MockPromptResource();

    when(() => promptResource.getPromptTerms(any()))
        .thenAnswer((_) => Future.value(['']));
  });

  group('PromptPage', () {
    testWidgets('renders prompt page', (tester) async {
      await tester.pumpSubject(promptResource);

      expect(find.byType(PromptView), findsOneWidget);
    });
  });
}

extension PromptPageTest on WidgetTester {
  Future<void> pumpSubject(PromptResource resource) {
    return pumpApp(
      Provider.value(
        value: resource,
        child: const PromptPage(),
      ),
    );
  }
}
