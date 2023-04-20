import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/prompt/prompt.dart';

class PromptView extends StatelessWidget {
  const PromptView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PromptFormBloc, PromptFormState>(
      listener: (context, state) {
        if (!state.prompts.props.contains(null)) {
          GoRouter.of(context).go('/draft', extra: state.prompts);
        }
      },
      builder: (context, state) {
        if ((state.status == PromptTermsStatus.initial) ||
            (state.status == PromptTermsStatus.loading)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.status == PromptTermsStatus.loaded) {
          return PromptForm();
        }
        return Scaffold(
          body: Center(
            child: Text(context.l10n.unknownConnectionError),
          ),
        );
      },
    );
  }
}
