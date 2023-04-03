import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/prompt/prompt.dart';

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

    return Scaffold(
      body: BlocProvider(
        create: (_) => PromptFormBloc(promptResource: promptResource),
        child: const PromptView(),
      ),
    );
  }
}
