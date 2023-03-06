import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class MatchMakingView extends StatelessWidget {
  const MatchMakingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchMakingBloc, MatchMakingState>(
      listener: (previous, next) {
        if (next.status == MatchMakingStatus.completed) {
          context.go('/game/${next.match?.id}');
        }
      },
      builder: (context, state) {
        if (state.status == MatchMakingStatus.processing ||
            state.status == MatchMakingStatus.initial) {
          return const Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == MatchMakingStatus.failed) {
          return const Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: Text('Match making failed, sorry!'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: TopDashColors.backgroundMain,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Host:'),
                Text(state.match?.host ?? ''),
                const Text('Guest:'),
                Text(state.match?.guest ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
