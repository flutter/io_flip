import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
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

    return Scaffold(
      backgroundColor: TopDashColors.backgroundMain,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _DraftDeck(),
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: TopDashSpacing.xxxlg,
                      ),
                    ),
                  ),
                  const _SelectedDeck(),
                ],
              ),
            ),
            const _BottomBar(),
          ],
        ),
      ),
    );
  }
}

class _DraftDeck extends StatelessWidget {
  const _DraftDeck();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;

    final translateTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 80),
    );

    final scaleTween = Tween<double>(
      begin: 1,
      end: .8,
    );

    const cardWidth = 230.0;
    const cardHeight = 328.0;

    final bottomPadding = translateTween.transform(1).dy -
        ((cardHeight * (1 - scaleTween.transform(1))) / 2);

    final showArrows = MediaQuery.of(context).size.width > 500;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showArrows) ...[
          IconButton(
            onPressed: () {
              bloc.add(const PreviousCard());
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: TopDashColors.black,
            ),
            iconSize: 20,
          ),
          const SizedBox(width: TopDashSpacing.xs),
        ],
        Padding(
          // Padding required to avoid widgets overlapping due to Stack child's
          // translations
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Stack(
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
                    child: Dismissible(
                      key: ValueKey(state.cards[i].id),
                      onDismissed: (direction) {
                        bloc.add(const CardSwiped());
                      },
                      onUpdate: (details) {
                        bloc.add(CardSwipeStarted(details.progress));
                      },
                      child: Opacity(
                        opacity: i == 0 ? state.firstCardOpacity : 1,
                        child: GameCard(
                          width: cardWidth,
                          height: cardHeight,
                          image: state.cards[i].image,
                          name: state.cards[i].name,
                          power: state.cards[i].power,
                          suitName: state.cards[i].suit.name,
                          isRare: state.cards[i].rarity,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showArrows) ...[
          const SizedBox(width: TopDashSpacing.xs),
          IconButton(
            onPressed: () {
              bloc.add(const NextCard());
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: TopDashColors.black,
            ),
            iconSize: 20,
          ),
        ],
      ],
    );
  }
}

class _SelectedDeck extends StatelessWidget {
  const _SelectedDeck();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xs),
            child: SelectedCard(i, key: ValueKey('SelectedCard$i')),
          ),
        ]
      ],
    );
  }
}

class SelectedCard extends StatelessWidget {
  const SelectedCard(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final selectedCards = bloc.state.selectedCards;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          bloc.add(const SelectCard());
        },
        child: Container(
          height: 136,
          width: 104,
          decoration: BoxDecoration(
            color: TopDashColors.lightBlue99,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              if (index < selectedCards.length) ...[
                Center(
                  child: Text(
                    '${selectedCards[index].name}\n'
                    '${selectedCards[index].power}',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
              Positioned(
                bottom: TopDashSpacing.xs,
                right: TopDashSpacing.xs,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: TopDashColors.lightBlue60,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(Assets.images.add.path),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    final viewPortHeight = MediaQuery.of(context).size.height;
    final isSmall = viewPortHeight < 700;

    return Container(
      padding: const EdgeInsets.all(TopDashSpacing.sm),
      height: isSmall ? 64 : 96,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: RoundedButton.icon(
              const Icon(Icons.question_mark_rounded),
              backgroundColor: Colors.white,
              onPressed: () => GoRouter.of(context).go('/how_to_play'),
            ),
          ),
          if (state.status == DraftStateStatus.deckSelected) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: _PrivateMatchButton(),
            ),
            Center(
              child: RoundedButton.text(
                l10n.joinMatch.toUpperCase(),
                onPressed: () {
                  GoRouter.of(context).goNamed(
                    'match_making',
                    queryParams: {'cardId': state.selectedCardIds()},
                  );
                },
              ),
            ),
          ] else ...[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.deckBuildingTitle,
                    style: TopDashTextStyles.mobile.titleSmall,
                  ),
                  const SizedBox(height: TopDashSpacing.xs),
                  Text(
                    l10n.deckBuildingSubtitle,
                    style: TopDashTextStyles.mobile.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}

class _PrivateMatchButton extends StatelessWidget {
  const _PrivateMatchButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    return ElevatedButton(
      onPressed: () async {
        final goRouter = GoRouter.of(context);
        final inviteCode = await showDialog<String?>(
          context: context,
          builder: (_) => _JoinPrivateMatchDialog(state.selectedCardIds()),
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
      child: const Text('Private match'),
    );
  }
}

class _JoinPrivateMatchDialog extends StatefulWidget {
  const _JoinPrivateMatchDialog(this.selectedCardIds);

  final List<String> selectedCardIds;

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
        height: 300,
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).goNamed(
                  'match_making',
                  queryParams: {
                    'createPrivateMatch': 'true',
                    'cardId': widget.selectedCardIds,
                  },
                );
              },
              child: const Text('Create private match'),
            ),
          ],
        ),
      ),
    );
  }
}
