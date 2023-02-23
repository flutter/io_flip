import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/style/palette.dart';

class MatchMakingView extends StatelessWidget {
  const MatchMakingView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    //final bloc = context.watch<MatchMakingBloc>();
    //final state = bloc.state;

    return BlocBuilder<MatchMakingBloc, MatchMakingState>(
      builder: (context, state) {
        print('BUILD');
        print(state.match);
        print(state.status);

        if (state.status == MatchMakingStatus.processing) {
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
                Text('Host: ${state.match?.host}'),
                Text('Guest: ${state.match?.guest}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
