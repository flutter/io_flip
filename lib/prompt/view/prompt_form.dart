import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

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

    return SimpleFlow(
      initialData: () => const Prompt(),
      onComplete: (data) {
        bloc.add(PromptSubmitted(data: data));
      },
      stepBuilder: (context, data, _) {
        final introSeen = data.isIntroSeen ?? false;
        if (!introSeen) {
          return const PromptFormIntroView();
        }
        if (data.characterClass == null) {
          return PromptFormView(
            title: context.l10n.characterClassPromptPageTitle,
            itemsList: bloc.state.characterClasses,
            initialItem: _rng.nextInt(bloc.state.characterClasses.length),
          );
        }

        return PromptFormView(
          title: context.l10n.powerPromptPageTitle,
          itemsList: bloc.state.powers,
          initialItem: _rng.nextInt(bloc.state.powers.length),
          isLastOfFlow: true,
        );
      },
    );
  }
}
