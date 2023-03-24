import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

class InitialsForm extends StatelessWidget {
  const InitialsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InitialsFormBloc(),
      child: const InitialsFormView(),
    );
  }
}
