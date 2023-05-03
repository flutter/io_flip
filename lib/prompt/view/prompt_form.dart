import 'dart:math' as math;

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/prompt/prompt.dart';

class PromptForm extends StatelessWidget {
  PromptForm({
    math.Random? randomGenerator,
    super.key,
  }) {
    _rng = randomGenerator ?? math.Random();
  }

  late final math.Random _rng;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PromptFormBloc>();
    return FlowBuilder<Prompt>(
      state: const Prompt(),
      onComplete: (data) {
        bloc.add(PromptSubmitted(data: data));
      },
      onGeneratePages: (data, pages) {
        return [
          const MaterialPage(
            child: PromptFormIntroView(),
          ),
          if (data.isIntroSeen ?? false)
            MaterialPage(
              child: PromptFormView(
                title: context.l10n.characterClassPromptPageTitle,
                itemsList: bloc.state.characterClasses,
                initialItem: _rng.nextInt(bloc.state.characterClasses.length),
              ),
            ),
          if (data.characterClass != null)
            MaterialPage(
              child: PromptFormView(
                title: context.l10n.powerPromptPageTitle,
                itemsList: bloc.state.powers,
                initialItem: _rng.nextInt(bloc.state.powers.length),
                isLastOfFlow: true,
              ),
            ),
        ];
      },
    );
  }
}
