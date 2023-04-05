import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/prompt/prompt.dart';

class PromptView extends StatelessWidget {
  const PromptView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PromptFormBloc, PromptFormState>(
      listener: (context, state) {
        if (!state.prompts.props.contains(null)) {
          GoRouter.of(context).go('/draft', extra: state.prompts);
        }
      },
      child: const PromptForm(),
    );
  }
}
