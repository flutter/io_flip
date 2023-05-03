import 'package:flop/flop/bloc/flop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlopView extends StatelessWidget {
  const FlopView({super.key});

  String _stepText(FlopStep step) {
    switch (step) {
      case FlopStep.initial:
        return 'Initializing';
      case FlopStep.authentication:
        return 'Authenticating';
      case FlopStep.deckDraft:
        return 'Drafting deck';
      case FlopStep.matchmaking:
        return 'Finding match';
      case FlopStep.joinedMatch:
        return 'Joined match';
      case FlopStep.playing:
        return 'Playing';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlopBloc, FlopState>(
      listenWhen: (previous, current) => previous.steps != current.steps,
      listener: (context, state) {
        context.read<FlopBloc>().add(const NextStepRequested());
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              width: 500,
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (final step in FlopStep.values)
                          Row(
                            children: [
                              Text(
                                state.steps.contains(step) ? '✅' : '⏱',
                              ),
                              const SizedBox(width: 16),
                              Text(_stepText(step)),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final message in state.messages) Text(message),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
