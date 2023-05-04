import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class _FlowData {
  _FlowData(
    this.step1,
    this.step2,
    this.step3,
  );

  final String? step1;
  final String? step2;
  final String? step3;

  _FlowData copyWith({
    String? step1,
    String? step2,
    String? step3,
  }) {
    return _FlowData(
      step1 ?? this.step1,
      step2 ?? this.step2,
      step3 ?? this.step3,
    );
  }

  @override
  String toString() {
    return '''
step 1: $step1
step 2: $step2
step 3: $step3''';
  }
}

class SimpleFlowStory extends StatelessWidget {
  const SimpleFlowStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Simple flow',
      body: SimpleFlow(
        initialData: () => _FlowData(null, null, null),
        onComplete: (data) {
          // open alert showing the complete data
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Flow completed!'),
                content: Text(data.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        stepBuilder: (context, data, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data.toString()),
              TextField(
                key: ValueKey(data),
                onSubmitted: (value) {
                  if (data.step1 == null) {
                    return context.updateFlow<_FlowData>((current) {
                      return current.copyWith(step1: value);
                    });
                  }

                  if (data.step2 == null) {
                    return context.updateFlow<_FlowData>((current) {
                      return current.copyWith(step2: value);
                    });
                  }

                  return context.completeFlow<_FlowData>((current) {
                    return current.copyWith(step3: value);
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
