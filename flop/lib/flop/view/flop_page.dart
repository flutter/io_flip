import 'package:flop/flop/flop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlopPage extends StatelessWidget {
  const FlopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlopBloc>(
      create: (_) => FlopBloc()..add(const NextStepRequested()),
      child: const FlopView(),
    );
  }
}
