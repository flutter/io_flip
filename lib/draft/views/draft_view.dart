import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

extension DraftViewX on DraftState {
  List<String> selectedCardIds() =>
      selectedCards.map((card) => card.id).toList();
}

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    if (state.status == DraftStateStatus.deckFailed) {
      return Scaffold(
        backgroundColor: TopDashColors.backgroundMain,
        body: Center(
          child: Text(l10n.cardGenerationError),
        ),
      );
    }

    if (state.status == DraftStateStatus.deckLoading ||
        state.status == DraftStateStatus.initial) {
      return const Scaffold(
        backgroundColor: TopDashColors.backgroundMain,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final translateTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 80),
    );

    final scaleTween = Tween<double>(
      begin: 1,
      end: .8,
    );

    return Scaffold(
      backgroundColor: TopDashColors.backgroundMain,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                for (var i = state.cards.length - 1; i >= 0; i--)
                  Transform.translate(
                    offset: translateTween.transform(
                      (i + 1) / state.cards.length,
                    ),
                    child: Transform.scale(
                      scale: scaleTween.transform(
                        (i + 1) / state.cards.length,
                      ),
                      child: GameCard(
                        width: 120,
                        height: 280,
                        card: state.cards[i],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 60),
            if (state.status == DraftStateStatus.deckSelected) ...[
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(
                    'match_making',
                    queryParams: {'cardId': state.selectedCardIds()},
                  );
                },
                child: Text(l10n.play),
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(
                    'match_making',
                    queryParams: {
                      'createPrivateMatch': 'true',
                      'cardId': state.selectedCardIds(),
                    },
                  );
                },
                child: const Text('Create private match'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final goRouter = GoRouter.of(context);
                  final inviteCode = await showDialog<String?>(
                    context: context,
                    builder: (_) => const _JoinPrivateMatchDialog(),
                  );
                  if (inviteCode != null) {
                    goRouter.goNamed(
                      'match_making',
                      queryParams: {
                        'inviteCode': inviteCode,
                        'cardId': state.selectedCardIds(),
                      },
                    );
                  }
                },
                child: const Text('Join Private match'),
              ),
            ] else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(const NextCard());
                    },
                    child: Text(l10n.nextCard),
                  ),
                  ElevatedButton(
                    onPressed: state.selectedCards.contains(state.cards.last)
                        ? null
                        : () {
                            bloc.add(const SelectCard());
                          },
                    child: Text(l10n.useCard),
                  ),
                ],
              ),
            const SizedBox(height: 60),
            Column(
              children: [
                for (final card in state.selectedCards)
                  Text(
                    '${card.name}: ${card.power}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinPrivateMatchDialog extends StatefulWidget {
  const _JoinPrivateMatchDialog();

  @override
  State<_JoinPrivateMatchDialog> createState() =>
      _JoinPrivateMatchDialogState();
}

class _JoinPrivateMatchDialogState extends State<_JoinPrivateMatchDialog> {
  String? inviteCode;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        height: 250,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Invite code',
              ),
              onChanged: (value) {
                setState(() {
                  inviteCode = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(inviteCode);
              },
              child: const Text('Join'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
