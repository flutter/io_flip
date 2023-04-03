import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _FakePromptFlowController extends FakeFlowController<FlowData> {
  _FakePromptFlowController() : super(const FlowData());
}

void main() {
  late FakeFlowController<FlowData> flowController;

  setUp(() {
    flowController = _FakePromptFlowController();
  });

  group('PromptFormView', () {
    testWidgets('flow updates correctly', (tester) async {
      await tester.pumpSubject(flowController);

      await tester.enterText(find.byType(TextFormField), 'text');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(flowController.state, equals(const FlowData(character: 'text')));
    });

    testWidgets('flow completes correctly', (tester) async {
      await tester.pumpSubject(flowController, isLast: true);

      await tester.enterText(find.byType(TextFormField), 'text');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(flowController.state, equals(const FlowData(character: 'text')));
      expect(flowController.completed, isTrue);
    });
  });
}

extension PromptFormViewTest on WidgetTester {
  Future<void> pumpSubject(
    FlowController<FlowData> flowController, {
    bool isLast = false,
  }) {
    return pumpApp(
      Scaffold(
        body: FlowBuilder<FlowData>(
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
