import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _FakePromptFlowController extends FakeFlowController<Prompt> {
  _FakePromptFlowController() : super(const Prompt());
}

void main() {
  late FakeFlowController<Prompt> flowController;

  setUp(() {
    flowController = _FakePromptFlowController();
  });

  group('PromptFormView', () {
    testWidgets('flow updates correctly', (tester) async {
      await tester.pumpSubject(flowController);

      await tester.enterText(find.byType(TextFormField), 'text');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(
          flowController.state, equals(const Prompt(characterClass: 'text')));
    });

    testWidgets('flow completes correctly', (tester) async {
      await tester.pumpSubject(flowController, isLast: true);

      await tester.enterText(find.byType(TextFormField), 'text');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(
          flowController.state, equals(const Prompt(characterClass: 'text')));
      expect(flowController.completed, isTrue);
    });
  });
}

extension PromptFormViewTest on WidgetTester {
  Future<void> pumpSubject(
    FlowController<Prompt> flowController, {
    bool isLast = false,
  }) {
    return pumpApp(
      Scaffold(
        body: FlowBuilder<Prompt>(
          controller: flowController,
          onGeneratePages: (data, pages) {
            return [
              MaterialPage(
                child: PromptFormView(
                  title: '',
                  subtitle: '',
                  hint: '',
                  buttonIcon: Icons.arrow_forward,
                  isLastOfFlow: isLast,
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
