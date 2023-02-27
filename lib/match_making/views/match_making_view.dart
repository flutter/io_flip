import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/style/palette.dart';

class MatchMakingView extends StatelessWidget {
  const MatchMakingView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    return BlocBuilder<MatchMakingBloc, MatchMakingState>(
      builder: (context, state) {
        if (state.status == MatchMakingStatus.processing ||
            state.status == MatchMakingStatus.initial) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == MatchMakingStatus.failed) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: const Center(
              child: Text('Match making failed, sorry!'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: palette.backgroundMain,
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
