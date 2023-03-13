import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:top_dash/scripts/cubit/scripts_cubit.dart';
import 'package:top_dash/style/snack_bar.dart';

class ScriptsView extends StatefulWidget {
  const ScriptsView({super.key});

  @override
  State<ScriptsView> createState() => _ScriptsViewState();
}

class _ScriptsViewState extends State<ScriptsView> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      language: javascript,
      text: context.read<ScriptsCubit>().state.current,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScriptsCubit, ScriptsState>(
      listener: (context, state) {
        if (state.status == ScriptsStateStatus.failed) {
          showSnackBar('Failed to update script');
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ScriptsStateStatus.loading;
        return CodeTheme(
          data: const CodeThemeData(styles: monokaiSublimeTheme),
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () {
                            context
                                .read<ScriptsCubit>()
                                .updateScript(_codeController.text);
                          },
                        ),
                ),
                Expanded(
                  child: CodeField(controller: _codeController),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
