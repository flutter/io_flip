import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/match_making/match_making.dart';

class MatchMakingPage extends StatelessWidget {
  const MatchMakingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final matchMaker = context.read<MatchMaker>();
        return MatchMakingBloc(matchMaker: matchMaker)
          ..add(
            const MatchRequested(),
          );
      },
      child: const MatchMakingView(),
    );
  }
}
