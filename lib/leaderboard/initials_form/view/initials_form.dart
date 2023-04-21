import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

class InitialsForm extends StatelessWidget {
  const InitialsForm({
    required this.scoreCardId,
    this.route,
    super.key,
  });

  final String scoreCardId;
  final void Function(BuildContext, String)? route;

  @override
  Widget build(BuildContext context) {
    final leaderboardResource = context.read<LeaderboardResource>();

    return BlocProvider(
      create: (_) => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: scoreCardId,
      ),
      child: InitialsFormView(
        route: route,
      ),
    );
  }
}
