import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip/how_to_play/how_to_play.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

const _handSize = GameCardSize.xs();
const _stackSize = GameCardSize.lg();

typedef CacheImageFunction = Future<void> Function(
  ImageProvider<Object> provider,
  BuildContext context,
);

class DraftView extends StatefulWidget {
  const DraftView({
    super.key,
    RouterNeglectCall routerNeglectCall = Router.neglect,
    String allowPrivateMatch =
        const String.fromEnvironment('ALLOW_PRIVATE_MATCHES'),
    CacheImageFunction cacheImage = precacheImage,
  })  : _routerNeglectCall = routerNeglectCall,
        _allowPrivateMatch = allowPrivateMatch,
        _cacheImage = cacheImage;

  final RouterNeglectCall _routerNeglectCall;
  final String _allowPrivateMatch;
  final CacheImageFunction _cacheImage;

  @override
  State<DraftView> createState() => _DraftViewState();
}

class _DraftViewState extends State<DraftView> {
  bool imagesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!imagesLoaded) {
      final bloc = context.read<DraftBloc>();
      if (bloc.state.status == DraftStateStatus.deckLoaded ||
          bloc.state.status == DraftStateStatus.deckSelected) {
        Future.wait([
          for (final card in bloc.state.cards)
            widget._cacheImage(NetworkImage(card.image), context),
        ]).then((_) {
          if (mounted) {
            setState(() {
              imagesLoaded = true;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    if (state.status == DraftStateStatus.deckFailed) {
      return IoFlipScaffold(
        body: Center(
          child: Text(l10n.cardGenerationError),
        ),
      );
    }

    if (state.status == DraftStateStatus.deckLoading ||
        state.status == DraftStateStatus.initial ||
        !imagesLoaded) {
      return const IoFlipScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DraftLoadedView(
      routerNeglectCall: widget._routerNeglectCall,
      allowPrivateMatch: widget._allowPrivateMatch,
    );
  }
}

class DraftLoadedView extends StatefulWidget {
  const DraftLoadedView({
    required RouterNeglectCall routerNeglectCall,
    required String allowPrivateMatch,
    super.key,
  })  : _routerNeglectCall = routerNeglectCall,
        _allowPrivateMatch = allowPrivateMatch;

  final RouterNeglectCall _routerNeglectCall;
  final String _allowPrivateMatch;

  @override
  State<DraftLoadedView> createState() => _DraftLoadedViewState();
}

class _DraftLoadedViewState extends State<DraftLoadedView> {
  static const _fadeInDuration = Duration(milliseconds: 450);
  static const _fadeInCurve = Curves.easeInOut;
  double get _uiOffset => uiVisible ? 0 : 48;
  bool uiVisible = false;

  @override
  Widget build(BuildContext context) {
    final stackHeight = 80 - (_stackSize.height * 0.1);
    final totalStackHeight = _stackSize.height + stackHeight;
    final uiHeight = totalStackHeight + _handSize.height;
    final screenSize = MediaQuery.sizeOf(context);
    final showArrows = screenSize.width > 500 && uiVisible;
    final center = screenSize.center(Offset.zero);

    return IoFlipScaffold(
      bottomBar: AnimatedSlide(
        duration: _fadeInDuration,
        curve: _fadeInCurve,
        offset: Offset(0, uiVisible ? 0 : 0.25),
        child: AnimatedOpacity(
          curve: _fadeInCurve,
          duration: _fadeInDuration,
          opacity: uiVisible ? 1 : 0,
          child: _BottomBar(
            routerNeglectCall: widget._routerNeglectCall,
            allowPrivateMatch: widget._allowPrivateMatch == 'true',
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: uiHeight + IoFlipSpacing.xxxlg,
              minHeight: uiHeight + IoFlipSpacing.lg,
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: _fadeInDuration,
                  curve: _fadeInCurve,
                  right: center.dx + _stackSize.width / 2 + IoFlipSpacing.xs,
                  top: _stackSize.height / 2 + _uiOffset,
                  child: AnimatedOpacity(
                    curve: _fadeInCurve,
                    duration: _fadeInDuration,
                    opacity: showArrows ? 1 : 0,
                    child: IconButton(
                      onPressed: () {
                        context.read<DraftBloc>().add(const PreviousCard());
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: IoFlipColors.seedWhite,
                      ),
                      iconSize: 20,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: _fadeInDuration,
                  curve: _fadeInCurve,
                  left: center.dx + _stackSize.width / 2 + IoFlipSpacing.xs,
                  top: _stackSize.height / 2 + _uiOffset,
                  child: AnimatedOpacity(
                    curve: _fadeInCurve,
                    duration: _fadeInDuration,
                    opacity: showArrows ? 1 : 0,
                    child: IconButton(
                      onPressed: () {
                        context.read<DraftBloc>().add(const NextCard());
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: IoFlipColors.seedWhite,
                      ),
                      iconSize: 20,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSlide(
                    duration: _fadeInDuration,
                    curve: _fadeInCurve,
                    offset: Offset(0, uiVisible ? 0 : 0.25),
                    child: AnimatedOpacity(
                      curve: _fadeInCurve,
                      duration: _fadeInDuration,
                      opacity: uiVisible ? 1 : 0,
                      child: const _SelectedDeck(),
                    ),
                  ),
                ),
                AnimatedAlign(
                  curve: _fadeInCurve,
                  duration: _fadeInDuration,
                  alignment: uiVisible ? Alignment.topCenter : Alignment.center,
                  child: AnimatedOpacity(
                    duration: _fadeInDuration,
                    opacity: uiVisible ? 1 : 0,
                    child: BlocBuilder<DraftBloc, DraftState>(
                      builder: (context, state) {
                        final cards = state.cards;
                        return _BackgroundCards(cards);
                      },
                    ),
                  ),
                ),
                AnimatedAlign(
                  curve: _fadeInCurve,
                  duration: _fadeInDuration,
                  alignment: uiVisible ? Alignment.topCenter : Alignment.center,
                  child: DeckPack(
                    onComplete: () {
                      setState(() {
                        uiVisible = true;
                      });
                    },
                    size: _stackSize.size,
                    child: const _TopCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  const _TopCard();

  @override
  Widget build(BuildContext context) {
    final card =
        context.select<DraftBloc, Card>((bloc) => bloc.state.cards.first);
    final opacity = context
        .select<DraftBloc, double>((bloc) => bloc.state.firstCardOpacity);
    return Dismissible(
      key: ValueKey(card.id),
      onDismissed: (direction) {
        context.read<DraftBloc>().add(const CardSwiped());
      },
      onUpdate: (details) {
        context.read<DraftBloc>().add(CardSwipeStarted(details.progress));
      },
      child: Opacity(
        opacity: opacity,
        child: GameCard(
          image: card.image,
          name: card.name,
          description: card.description,
          power: card.power,
          suitName: card.suit.name,
          isRare: card.rarity,
        ),
      ),
    );
  }
}

class _BackgroundCards extends StatelessWidget {
  const _BackgroundCards(this.cards);

  final List<Card> cards;

  @override
  Widget build(BuildContext context) {
    final translateTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 80),
    );

    final scaleTween = Tween<double>(
      begin: 1,
      end: .8,
    );

    final bottomPadding = translateTween.transform(1).dy -
        ((_stackSize.height * (1 - scaleTween.transform(1))) / 2);

    return Padding(
      // Padding required to avoid widgets overlapping due to Stack child's
      // translations
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          for (var i = cards.length - 1; i > 0; i--)
            Transform.translate(
              offset: translateTween.transform(
                i / cards.length,
              ),
              child: Transform.scale(
                scale: scaleTween.transform(
                  i / cards.length,
                ),
                child: GameCard(
                  image: cards[i].image,
                  name: cards[i].name,
                  description: cards[i].description,
                  power: cards[i].power,
                  suitName: cards[i].suit.name,
                  isRare: cards[i].rarity,
                ),
              ),
            ),
        ],
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: IoFlipSpacing.xs),
            child: SelectedCard(
              i,
              key: ValueKey('SelectedCard$i'),
            ),
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
    final card = index < selectedCards.length ? selectedCards[index] : null;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          bloc.add(SelectCard(index));
        },
        child: Container(
          width: _handSize.width,
          height: _handSize.height,
          decoration: card == null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(IoFlipSpacing.sm),
                  border: Border.all(color: IoFlipColors.seedGrey90),
                )
              : null,
          child: Stack(
            children: [
              if (card != null)
                GameCard(
                  image: card.image,
                  name: card.name,
                  description: card.description,
                  suitName: card.suit.name,
                  power: card.power,
                  isRare: card.rarity,
                  size: const GameCardSize.xs(),
                )
              else
                Positioned(
                  bottom: IoFlipSpacing.xs,
                  right: IoFlipSpacing.xs,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: IoFlipColors.seedWhite,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 2,
                        color: IoFlipColors.seedBlack,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(-2, 2),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, size: 32),
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
  const _BottomBar({
    required this.routerNeglectCall,
    required this.allowPrivateMatch,
  });

  final RouterNeglectCall routerNeglectCall;
  final bool allowPrivateMatch;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    return IoFlipBottomBar(
      leading: const AudioToggleButton(),
      middle: state.status == DraftStateStatus.deckSelected
          ? RoundedButton.text(
              l10n.joinMatch.toUpperCase(),
              onPressed: () => routerNeglectCall(
                context,
                () => GoRouter.of(context).goNamed(
                  'match_making',
                  extra: MatchMakingPageData(
                    cards: state.selectedCards.cast<Card>(),
                  ),
                ),
              ),
              onLongPress: allowPrivateMatch
                  ? () => showPrivateMatchDialog(context)
                  : null,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.deckBuildingTitle,
                  style: IoFlipTextStyles.mobileH6Light,
                ),
                const SizedBox(height: IoFlipSpacing.xs),
                Text(
                  l10n.deckBuildingSubtitle,
                  style: IoFlipTextStyles.bodySM,
                ),
              ],
            ),
      trailing: RoundedButton.icon(
        Icons.question_mark_rounded,
        onPressed: () => IoFlipDialog.show(
          context,
          child: const HowToPlayDialog(),
        ),
      ),
    );
  }

  void showPrivateMatchDialog(BuildContext context) {
    final bloc = context.read<DraftBloc>();
    final state = bloc.state;
    final goRouter = GoRouter.of(context);

    showDialog<String?>(
      context: context,
      builder: (_) => _JoinPrivateMatchDialog(
        selectedCards: state.selectedCards.cast<Card>(),
        routerNeglectCall: routerNeglectCall,
      ),
    ).then((inviteCode) {
      if (inviteCode != null) {
        routerNeglectCall(
          context,
          () => goRouter.goNamed(
            'match_making',
            queryParams: {
              'inviteCode': inviteCode,
            },
            extra: MatchMakingPageData(cards: state.selectedCards.cast<Card>()),
          ),
        );
      }
      return inviteCode;
    });
  }
}

class _JoinPrivateMatchDialog extends StatefulWidget {
  const _JoinPrivateMatchDialog({
    required this.selectedCards,
    required this.routerNeglectCall,
  });

  final List<Card> selectedCards;
  final RouterNeglectCall routerNeglectCall;

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
              onPressed: () => widget.routerNeglectCall(
                context,
                () => GoRouter.of(context).goNamed(
                  'match_making',
                  queryParams: {
                    'createPrivateMatch': 'true',
                  },
                  extra: MatchMakingPageData(cards: widget.selectedCards),
                ),
              ),
              child: const Text('Create private match'),
            ),
          ],
        ),
      ),
    );
  }
}
