import 'package:flop/flop/flop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlopPage extends StatelessWidget {
  const FlopPage({
    super.key,
    required this.setAppCheckDebugToken,
    required this.reload,
  });

  final void Function(String) setAppCheckDebugToken;
  final void Function() reload;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlopBloc>(
      create: (_) => FlopBloc(
        setAppCheckDebugToken: setAppCheckDebugToken,
        reload: reload,
      )..add(const NextStepRequested()),
      child: const FlopView(),
    );
  }
}
