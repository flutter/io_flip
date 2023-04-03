import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/prompt/prompt.dart';

class PromptPage extends StatelessWidget {
  const PromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final promptResource = context.read<PromptResource>();
    return Scaffold(
      body: BlocProvider(
        create: (_) => PromptFormBloc(promptResource: promptResource),
        child: const PromptForm(),
      ),
    );
  }
}
