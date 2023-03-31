import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _MockPromptResource extends Mock implements PromptResource {}

void main() {
  late PromptResource promptResource;

  setUp(() {
    promptResource = _MockPromptResource();

    when(() => promptResource.getPromptWhitelist())
        .thenAnswer((invocation) => Future.value(['']));
  });

  group('PromptPage', () {
    testWidgets('renders prompt page', (tester) async {
      await tester.pumpSubject(promptResource);

      expect(find.byType(PromptForm), findsOneWidget);
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
