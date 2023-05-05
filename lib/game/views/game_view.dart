import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/leaderboard/leaderboard.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

extension on List<TickerFuture> {
  Future<void> get allDone => Future.wait(
        map(
          (t) => t.orCancel.then((_) {}, onError: (_) {}),
        ),
      );
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (previous, current) =>
          context.read<GameBloc>().matchCompleted(current),
      listener: (context, state) {
        context.read<GameBloc>().sendMatchLeft();
      },
      builder: (context, state) {
        final Widget child;

        if (state is MatchLoadingState) {
          child = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MatchLoadFailedState) {
          child = const Center(
            child: Text('Unable to join game!'),
          );
        } else if (state is MatchLoadedState) {
          if (state.matchState.result != null && state.turnAnimationsFinished) {
            return const GameSummaryView();
          }
          child = const _GameBoard();
        } else if (state is LeaderboardEntryState) {
          child = LeaderboardEntryView(
            scoreCardId: state.scoreCardId,
            shareHandPageData: state.shareHandPageData,
          );
        } else if (state is OpponentAbsentState) {
          child = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Opponent left the game!'),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: const Text('Replay'),
                ),
              ],
            ),
          );
        } else {
          child = const SizedBox();
        }

        return IoFlipScaffold(
          body: child,
        );
      },
    );
  }
}

const clashCardSize = GameCardSize.md();
const playerHandCardSize = GameCardSize.xs();
const opponentHandCardSize = GameCardSize.xxs();
const counterSize = Size(56, 56);

const cardSpacingX = IoFlipSpacing.sm;
const cardSpacingY = IoFlipSpacing.xlg;
const cardsAtHand = 3;

const movingCardDuration = Duration(milliseconds: 400);
const droppedCardDuration = Duration(milliseconds: 200);
const turnEndDuration = Duration(milliseconds: 250);

class _GameBoard extends StatefulWidget {
  const _GameBoard();

  @override
  State<_GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<_GameBoard> with TickerProviderStateMixin {
  Offset? pointerStartPosition;
  Offset? pointerPosition;
  int? draggingCardIndex;
  bool draggingCardAccepted = false;
  bool didPlayerPlay = false;
  bool cardLandingShown = false;

  final boardSize = Size(
    2 * clashCardSize.width + 2 * cardSpacingX,
    opponentHandCardSize.height +
        cardSpacingY +
        clashCardSize.height +
        cardSpacingY +
        playerHandCardSize.height,
  );

  Size screenSize = Size.zero;
  late Offset boardOffset;
  late List<Offset> opponentCardOffsets;
  late List<Offset> clashCardOffsets;
  late List<Offset> playerCardStartOffsets;
  late List<Offset> playerCardOffsets;
  late List<GameCardSize> playerCardSizes;
  late Offset counterOffset;
  VelocityTracker? velocityTracker;

  final velocity = ValueNotifier<Offset>(Offset.zero);

  late List<Tween<GameCardRect?>> playerCardTweens;
  late List<Animation<GameCardRect?>> opponentCardAnimations;
  final List<TickerFuture> _runningPlayerAnimations = [];
  final List<TickerFuture> _runningOpponentAnimations = [];
  List<AnimationController> clashControllers = [];

  List<AnimationController> createAnimationControllers() {
    return List.generate(
      cardsAtHand,
      (index) => AnimationController(
        duration: movingCardDuration,
        vsync: this,
      ),
    );
  }

  late final opponentCardControllers = createAnimationControllers();
  late final playerCardControllers = createAnimationControllers();
  late final tiltTicker = createTicker(onTiltTick);
  late final playerAnimatedCardControllers = List.generate(
    cardsAtHand,
    (_) => AnimatedCardController(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newScreenSize = MediaQuery.sizeOf(context);

    if (newScreenSize != screenSize) {
      if (screenSize == Size.zero) {
        layoutAll();
      }
      screenSize = newScreenSize;
      boardOffset = Offset(
        (screenSize.width - boardSize.width) / 2,
        (screenSize.height - boardSize.height) / 2,
      );
    }
  }

  /// Lays out all the game board elements for the first time.
  void layoutAll() {
    // Counter position
    late final counterY = opponentHandCardSize.height +
        cardSpacingY +
        (clashCardSize.height - counterSize.height) / 2;

    late final counterX =
        (2 * clashCardSize.width + cardSpacingX - counterSize.width) / 2;

    counterOffset = Offset(counterX, counterY);

    // Player card start position calculations
    late final playerLeftPadding = (boardSize.width -
            cardsAtHand * (playerHandCardSize.width + cardSpacingX)) /
        2;

    final playerCardPositionY = opponentHandCardSize.height +
        cardSpacingY +
        clashCardSize.height +
        cardSpacingY;

    playerCardStartOffsets = List.generate(
      cardsAtHand,
      (index) => Offset(
        index * (playerHandCardSize.width + cardSpacingX) + playerLeftPadding,
        playerCardPositionY,
      ),
    );

    // Opponent card position calculations
    final opponentLeftPadding = (boardSize.width -
            cardsAtHand * (opponentHandCardSize.width + cardSpacingX)) /
        2;

    opponentCardOffsets = List.generate(
      cardsAtHand,
      (index) => Offset(
        index * (opponentHandCardSize.width + cardSpacingX) +
            opponentLeftPadding,
        0,
      ),
    );

    // Clash zone card position calculations
    final clashCardPositionY = opponentHandCardSize.height + cardSpacingY;

    clashCardOffsets = [
      Offset(0, clashCardPositionY),
      Offset(clashCardSize.width + 2 * cardSpacingX, clashCardPositionY),
    ];

    playerCardOffsets = List.of(playerCardStartOffsets);
    playerCardSizes = List.filled(cardsAtHand, playerHandCardSize);

    resetCardAnimations();
  }

  /// Resets all card animations and animation controllers. This is called
  /// when the game is reset in between turns.
  void resetCardAnimations() {
    for (final controller in opponentCardControllers) {
      controller.reset();
    }
    for (final controller in playerCardControllers) {
      controller.reset();
    }

    opponentCardAnimations = List.generate(
      cardsAtHand,
      (i) => opponentCardControllers[i].drive(
        GameCardRectTween(
          begin: GameCardRect(
            offset: opponentCardOffsets[i],
            gameCardSize: opponentHandCardSize,
          ),
          end: GameCardRect(
            offset: clashCardOffsets.first,
            gameCardSize: clashCardSize,
          ),
        ),
      ),
    );

    playerCardTweens = List.generate(
      cardsAtHand,
      (i) => GameCardRectTween(
        begin: GameCardRect(
          offset: playerCardStartOffsets[i],
          gameCardSize: playerHandCardSize,
        ),
        end: GameCardRect(
          offset: clashCardOffsets.last,
          gameCardSize: clashCardSize,
        ),
      ),
    );
  }

  int? _getCardForOffset(Offset offset) {
    for (var i = 0; i < playerCardStartOffsets.length; i++) {
      final cardRect =
          (playerCardStartOffsets[i] + boardOffset) & playerHandCardSize.size;
      if (cardRect.contains(offset)) {
        return i;
      }
    }

    return null;
  }

  void _onPanStart(DragStartDetails event) {
    if (draggingCardIndex != null) _onPanEnd();
    final cardIndex = _getCardForOffset(event.localPosition);
    if (cardIndex == null) return;

    final bloc = context.read<GameBloc>();
    final card = bloc.playerCards[cardIndex];
    if (bloc.canPlayerPlay(card.id)) {
      setState(() {
        pointerStartPosition = event.localPosition;
        pointerPosition = event.localPosition;
        draggingCardIndex = cardIndex;
        velocityTracker =
            VelocityTracker.withKind(event.kind ?? PointerDeviceKind.touch);
        tiltTicker.start();
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails event) {
    if (pointerPosition != null &&
        pointerStartPosition != null &&
        draggingCardIndex != null) {
      pointerPosition = event.localPosition;
      final goalRect =
          (clashCardOffsets.last + boardOffset) & clashCardSize.size;
      final goalY = goalRect.center.dy;
      final startDistance = pointerStartPosition!.dy - goalY;
      final currentDistance = pointerPosition!.dy - goalY;
      final progressY = 1.0 - (currentDistance / startDistance).clamp(0, 1);
      final relativeOffset = pointerPosition! - pointerStartPosition!;
      if (event.sourceTimeStamp != null) {
        velocityTracker?.addPosition(
          event.sourceTimeStamp!,
          event.localPosition,
        );
      }

      setState(() {
        draggingCardAccepted = goalRect.contains(pointerPosition!);
        playerCardSizes[draggingCardIndex!] = GameCardSize.lerp(
          playerHandCardSize,
          clashCardSize,
          progressY,
        )!;
        playerCardOffsets[draggingCardIndex!] =
            playerCardStartOffsets[draggingCardIndex!] + relativeOffset;
      });
    }
  }

  void _onPanEnd([_]) {
    final i = draggingCardIndex;
    if (i == null) return;

    playerCardTweens[i].begin = GameCardRect(
      offset: playerCardOffsets[i],
      gameCardSize: playerCardSizes[i],
    );
    final played = draggingCardAccepted && tryToPlayCard(i);
    if (played) {
      playerCardOffsets[i] = clashCardOffsets.last;
      playerCardSizes[i] = clashCardSize;
      playerCardTweens[i].end = GameCardRect(
        offset: clashCardOffsets.last,
        gameCardSize: clashCardSize,
      );
    } else {
      playerCardOffsets[i] = playerCardStartOffsets[i];
      playerCardSizes[i] = playerHandCardSize;

      playerCardTweens[i].end = GameCardRect(
        offset: playerCardStartOffsets[i],
        gameCardSize: playerHandCardSize,
      );
    }
    playerCardControllers[i].reset();
    _runningPlayerAnimations.add(
      playerCardControllers[i].animateTo(
        1,
        duration: droppedCardDuration,
        curve: Curves.easeOut,
      ),
    );

    setState(() {
      pointerPosition = null;
      pointerStartPosition = null;
      draggingCardIndex = null;
      draggingCardAccepted = false;
      velocity.value = Offset.zero;
      tiltTicker.stop();
      velocityTracker = null;
    });
  }

  void onTiltTick(_) {
    const scale = 1 / 500;
    final pps = velocityTracker
        ?.getVelocity()
        .clampMagnitude(0, 1 / scale)
        .pixelsPerSecond;
    if (pps != null) {
      velocity.value = pps * scale;
    }
  }

  void _onTapUp(TapUpDetails event) {
    final index = _getCardForOffset(event.localPosition);
    if (index != null) {
      final played = tryToPlayCard(index);

      if (played) {
        final controller = playerCardControllers[index];

        playerCardTweens[index].begin = GameCardRect(
          offset: playerCardStartOffsets[index],
          gameCardSize: playerHandCardSize,
        );
        playerCardTweens[index].end = GameCardRect(
          offset: clashCardOffsets.last,
          gameCardSize: clashCardSize,
        );
        _runningPlayerAnimations.add(controller.forward(from: 0));
      }
    }
  }

  bool tryToPlayCard(int index) {
    final bloc = context.read<GameBloc>();
    final card = bloc.playerCards[index];
    if (bloc.state is MatchLoadedState) {
      final state = bloc.state as MatchLoadedState;
      if (bloc.canPlayerPlay(card.id) && state.turnAnimationsFinished) {
        context.read<GameBloc>().add(PlayerPlayed(card.id));
        context.read<AudioController>().playSfx(Assets.sfx.cardMovement);
        didPlayerPlay = true;
        return true;
      }
    }

    return false;
  }

  Future<void> clashSceneCompleted() async {
    final bloc = context.read<GameBloc>()..add(const ClashSceneCompleted());
    for (final controller in clashControllers) {
      controller.value = 1;
    }

    await Future.wait([
      for (final controller in clashControllers)
        Future.delayed(turnEndDuration, () => controller.reverse(from: 1)),
    ]);
    await playerAnimatedCardControllers[lastPlayedPlayerCardIndex!]
        .run(bigFlipAnimation);
    clashControllers = [];
    bloc
      ..add(const TurnAnimationsFinished())
      ..add(const TurnTimerStarted());
  }

  int? lastPlayedPlayerCardIndex;
  int? lastPlayedOpponentCardIndex;

  @override
  Widget build(BuildContext context) {
    final playerCards =
        context.select<GameBloc, List<Card>>((bloc) => bloc.playerCards);
    final opponentCards =
        context.select<GameBloc, List<Card>>((bloc) => bloc.opponentCards);

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) {
        if (previous is MatchLoadedState && current is MatchLoadedState) {
          return previous.rounds != current.rounds ||
              previous.showCardLanding != current.showCardLanding;
        }
        return false;
      },
      listener: (context, state) async {
        if (state is MatchLoadedState) {
          final bloc = context.read<GameBloc>();
          final lastPlayedCardId = state.lastPlayedCardId;

          final playerIndex = playerCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          final opponentIndex = opponentCards
              .indexWhere((element) => element.id == lastPlayedCardId);

          if (playerIndex >= 0) {
            final controller = playerCardControllers[playerIndex];
            lastPlayedPlayerCardIndex = playerIndex;

            draggingCardAccepted = false;
            _onPanEnd();

            if (!didPlayerPlay) {
              final animation = playerCardTweens[playerIndex];
              animation
                ..begin = animation.evaluate(controller)
                ..end = GameCardRect(
                  offset: clashCardOffsets.last,
                  gameCardSize: clashCardSize,
                );
              _runningPlayerAnimations.add(controller.forward(from: 0));
            }

            clashControllers.add(controller);
            await _runningPlayerAnimations.allDone;
            _runningPlayerAnimations.add(
              playerAnimatedCardControllers[playerIndex].run(bigFlipAnimation),
            );
            Future.delayed(bigFlipAnimation.duration * .85, () {
              cardLandingShown = true;
              context.read<GameBloc>().add(const CardLandingStarted());
            });
          }
          if (opponentIndex >= 0) {
            lastPlayedOpponentCardIndex = opponentIndex;
            final controller = opponentCardControllers[opponentIndex];
            _runningOpponentAnimations.add(controller.forward());
            clashControllers.add(controller);
          }

          if (state.rounds.isNotEmpty) {
            if (cardLandingShown &&
                !state.showCardLanding &&
                state.rounds.last.isComplete()) {
              await _runningPlayerAnimations.allDone;
              await _runningOpponentAnimations.allDone;

              _runningPlayerAnimations.clear();
              _runningOpponentAnimations.clear();

              resetCardAnimations();

              didPlayerPlay = false;
              cardLandingShown = false;

              bloc.add(const ClashSceneStarted());
            }
          }
        }
      },
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTapUp: _onTapUp,
        child: Stack(
          children: [
            Transform.scale(
              scale: 1.4,
              child: Center(
                child: Image.asset(
                  platformAwareAsset(
                    desktop: Assets.images.stadiumBackground.keyName,
                    mobile: Assets.images.mobile.stadiumBackground.keyName,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SizedBox.fromSize(
                size: boardSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (final offset in playerCardStartOffsets)
                      _PlaceholderCard(
                        rect: offset & playerHandCardSize.size,
                      ),
                    for (final offset in opponentCardOffsets)
                      _PlaceholderCard(
                        rect: offset & opponentHandCardSize.size,
                      ),
                    ...clashCardOffsets.mapIndexed(
                      (i, offset) {
                        var rect = offset & clashCardSize.size;
                        if (i == 1 && draggingCardAccepted) {
                          rect = rect.inflate(8);
                        }
                        return _ClashCard(
                          key: Key('clash_card_$i'),
                          rect: rect,
                          showPlus: i == 1,
                        );
                      },
                    ),
                    ...opponentCards.mapIndexed(
                      (i, card) {
                        return _OpponentCard(
                          card: card,
                          animation: opponentCardAnimations[i],
                        );
                      },
                    ),
                    const _CardLandingPuffEffect(),
                    for (var i = 0; i < playerCards.length; i++)
                      AnimatedBuilder(
                        animation: playerCardControllers[i],
                        builder: (context, _) => ValueListenableBuilder(
                          valueListenable: i == draggingCardIndex
                              ? velocity
                              : const AlwaysStoppedAnimation(Offset.zero),
                          builder: (context, velocity, child) => _PlayerCard(
                            card: playerCards[i],
                            isDragging: i == draggingCardIndex,
                            velocity: velocity,
                            rect: i == draggingCardIndex
                                ? GameCardRect(
                                    gameCardSize: playerCardSizes[i],
                                    offset: playerCardOffsets[i],
                                  )
                                : playerCardTweens[i]
                                    .evaluate(playerCardControllers[i])!,
                            animatedCardController:
                                playerAnimatedCardControllers[i],
                          ),
                        ),
                      ),
                    _BoardCounter(counterOffset),
                  ],
                ),
              ),
            ),
            _ClashScene(
              onFinished: clashSceneCompleted,
              boardSize: boardSize,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    final controllers = [
      ...playerCardControllers,
      ...opponentCardControllers,
    ];
    for (final element in controllers) {
      element.dispose();
    }

    for (final element in playerAnimatedCardControllers) {
      element.dispose();
    }
    tiltTicker.dispose();

    super.dispose();
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.rect});

  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: IoFlipColors.seedWhite.withOpacity(0.15),
          borderRadius: BorderRadius.circular(rect.width * 0.08),
          border: Border.all(
            color: IoFlipColors.seedPaletteNeutral95,
          ),
        ),
        child: Opacity(
          opacity: 0.6,
          child: IoFlipLogo.white(
            width: rect.width - 20,
          ),
        ),
      ),
    );
  }
}

class _OpponentCard extends StatelessWidget {
  const _OpponentCard({
    required this.card,
    required this.animation,
  });

  final game.Card card;
  final Animation<GameCardRect?> animation;

  @override
  Widget build(BuildContext context) {
    final overlay = context.select<GameBloc, CardOverlayType?>(
      (bloc) => bloc.isWinningCard(card, isPlayer: false),
    );

    final alreadyPlayed = context.select<GameBloc, bool>((bloc) {
      if (bloc.state is MatchLoadedState) {
        final state = bloc.state as MatchLoadedState;
        return state.rounds.any((element) => element.opponentCardId == card.id);
      }
      return false;
    });

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final position = animation.value!;
        return Positioned.fromRect(
          key: Key('opponent_card_${card.id}'),
          rect: position.rect,
          child: alreadyPlayed && animation.isDismissed
              ? Stack(
                  children: [
                    GameCard(
                      key: Key('opponent_revealed_card_${card.id}'),
                      image: card.image,
                      name: card.name,
                      description: card.description,
                      power: card.power,
                      suitName: card.suit.name,
                      isRare: card.rarity,
                      size: position.gameCardSize,
                      overlay: overlay,
                    ),
                  ],
                )
              : FlippedGameCard(
                  key: Key('opponent_hidden_card_${card.id}'),
                  size: const GameCardSize.xxs(),
                ),
        );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.card,
    required this.rect,
    required this.animatedCardController,
    required this.isDragging,
    required this.velocity,
  });

  final game.Card card;
  final GameCardRect rect;
  final AnimatedCardController animatedCardController;
  final bool isDragging;
  final Offset velocity;

  @override
  Widget build(BuildContext context) {
    final overlay = context.select<GameBloc, CardOverlayType?>(
      (bloc) => bloc.isWinningCard(card, isPlayer: true),
    );

    return Positioned.fromRect(
      key: Key('player_card_${card.id}'),
      rect: rect.rect,
      child: MouseRegion(
        cursor:
            isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: AnimatedCard(
          controller: animatedCardController,
          front: GameCard(
            tilt: velocity,
            image: card.image,
            name: card.name,
            description: card.description,
            power: card.power,
            suitName: card.suit.name,
            isRare: card.rarity,
            size: rect.gameCardSize,
            overlay: overlay,
          ),
          back: const FlippedGameCard(
            size: GameCardSize.xxs(),
          ),
        ),
      ),
    );
  }
}

class _ClashCard extends StatelessWidget {
  const _ClashCard({
    required this.rect,
    required this.showPlus,
    super.key,
  });

  final Rect rect;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned.fromRect(
      duration: const Duration(milliseconds: 200),
      rect: rect,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: IoFlipColors.seedWhite.withOpacity(0.15),
          borderRadius: BorderRadius.circular(rect.width * 0.08),
          border: Border.all(
            color: IoFlipColors.seedPaletteNeutral95,
          ),
        ),
        child: showPlus
            ? const SizedBox.square(
                dimension: 57,
                child: CustomPaint(painter: CrossPainter()),
              )
            : const SizedBox(),
      ),
    );
  }
}

@visibleForTesting
class CrossPainter extends CustomPainter {
  const CrossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = IoFlipColors.seedWhite
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      )
      ..drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CrossPainter oldDelegate) => false;
}

class _BoardCounter extends StatelessWidget {
  const _BoardCounter(this.counterOffset);

  final Offset counterOffset;

  @override
  Widget build(BuildContext context) {
    final turnTimeRemaining = context.select(
      (GameBloc bloc) => bloc.state is MatchLoadedState
          ? (bloc.state as MatchLoadedState).turnTimeRemaining
          : 0,
    );

    return Positioned(
      left: counterOffset.dx,
      top: counterOffset.dy,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: IoFlipColors.seedWhite.withOpacity(.25),
            width: 8,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          width: counterSize.width,
          height: counterSize.height,
          decoration: BoxDecoration(
            color: IoFlipColors.seedWhite,
            shape: BoxShape.circle,
            border: Border.all(color: IoFlipColors.seedBlack, width: 2),
          ),
          child: Text(
            '$turnTimeRemaining',
            style: IoFlipTextStyles.cardNumberLG
                .copyWith(color: IoFlipColors.seedBlack),
          ),
        ),
      ),
    );
  }
}

class _CardLandingPuffEffect extends StatelessWidget {
  const _CardLandingPuffEffect();

  @override
  Widget build(BuildContext context) {
    final showCardLanding = context.select<GameBloc, bool>(
      (bloc) =>
          bloc.state is MatchLoadedState &&
          (bloc.state as MatchLoadedState).showCardLanding,
    );
    if (showCardLanding) {
      return Positioned(
        top: -20,
        right: -160,
        child: CardLandingPuff(
          playing: showCardLanding,
          onComplete: () {
            context.read<GameBloc>().add(const CardLandingCompleted());
          },
        ),
      );
    }
    return const SizedBox();
  }
}

class _ClashScene extends StatelessWidget {
  const _ClashScene({
    required this.onFinished,
    required this.boardSize,
  });

  final VoidCallback onFinished;
  final Size boardSize;

  @override
  Widget build(BuildContext context) {
    final isClashScene = context.select<GameBloc, bool>(
      (bloc) =>
          bloc.state is MatchLoadedState &&
          (bloc.state as MatchLoadedState).isClashScene,
    );

    if (isClashScene) {
      final opponentCard = context.select<GameBloc, Card>(
        (bloc) => bloc.lastPlayedOpponentCard,
      );
      final playerCard = context.select<GameBloc, Card>(
        (bloc) => bloc.lastPlayedPlayerCard,
      );
      return Positioned.fill(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1.4,
              child: Center(
                child: Image.asset(
                  platformAwareAsset(
                    desktop: Assets.images.stadiumBackgroundCloseUp.keyName,
                    mobile:
                        Assets.images.mobile.stadiumBackgroundCloseUp.keyName,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox.fromSize(
              size: boardSize,
              child: ClashScene(
                onFinished: onFinished,
                opponentCard: opponentCard,
                playerCard: playerCard,
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
