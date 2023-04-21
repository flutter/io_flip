import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash/share/share.dart';

class InitialsForm extends StatelessWidget {
  const InitialsForm({
    required this.scoreCardId,
    this.shareHandPageData,
    super.key,
  });

  final String scoreCardId;
  final ShareHandPageData? shareHandPageData;

  @override
  Widget build(BuildContext context) {
    final leaderboardResource = context.read<LeaderboardResource>();

    return BlocProvider(
      create: (_) => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: scoreCardId,
      ),
      child: InitialsFormView(
        shareHandPageData: shareHandPageData,
      ),
    );
  }
}
