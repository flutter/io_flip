import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/style/palette.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    if (state.status == DraftStateStatus.cardFailed) {
      return Scaffold(
        backgroundColor: palette.backgroundMain,
        body: Center(
          child: Text(l10n.cardGenerationError),
        ),
      );
    }

    return BlocListener<DraftBloc, DraftState>(
      listenWhen: (old, current) => old.cards.length != current.cards.length,
      listener: (context, state) {
        if (state.status != DraftStateStatus.deckCompleted) {
          bloc.add(const CardRequested());
        }
      },
      child: Scaffold(
        backgroundColor: palette.backgroundMain,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  for (var i = 0; i < state.cards.length; i++)
                    Transform.rotate(
                      angle: -.12,
                      child: Transform.translate(
                        offset: Offset(i * 40, i * 40),
                        child: Transform.rotate(
                          angle: i * .4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: palette.backgroundSettings,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 200,
                            height: 350,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Text(state.cards[i].name),
                                const SizedBox(height: 8),
                                Image.network(
                                  state.cards[i].image,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 120),
              if (state.status != DraftStateStatus.deckCompleted) ...[
                const CircularProgressIndicator(),
                Text(l10n.generatingCards(state.cards.length + 1, 3)),
              ],
              if (state.status == DraftStateStatus.deckCompleted)
                ElevatedButton(
                  onPressed: () {
                    // TODO(erickzanardo): navigate to the lobby when
                    // implemented
                  },
                  child: Text(l10n.play),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
