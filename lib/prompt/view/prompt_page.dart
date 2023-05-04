import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/prompt/prompt.dart';

class PromptPage extends StatelessWidget {
  const PromptPage({super.key});

  factory PromptPage.routeBuilder(_, __) {
    return const PromptPage(
      key: Key('prompt_page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final promptResource = context.read<PromptResource>();

    return BlocProvider(
      create: (_) => PromptFormBloc(promptResource: promptResource)
        ..add(const PromptTermsRequested()),
      child: const PromptView(),
    );
  }
}
