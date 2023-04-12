import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class HowToPlayView extends StatelessWidget {
  const HowToPlayView({super.key});

  static const numSteps = HowToPlayState.numSteps;

  @override
  Widget build(BuildContext context) {
    final selectedPageIndex = context.select<HowToPlayBloc, int>(
      (bloc) => bloc.state.position,
    );

    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(width: 400, height: 584),
        margin: const EdgeInsets.all(TopDashSpacing.sm),
        padding: const EdgeInsets.all(TopDashSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: TopDashColors.seedWhite,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(
                  child: HowToPlayStepView(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TopDashSpacing.xlg,
                    horizontal: TopDashSpacing.xxxlg,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      numSteps,
                      (index) => Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedPageIndex == index
                              ? TopDashColors.seedBlue
                              : TopDashColors.seedGrey70,
                        ),
                      ),
                    ),
                  ),
                ),
                RoundedButton.icon(
                  const Icon(Icons.arrow_forward),
                  onPressed: () {
                    final bloc = context.read<HowToPlayBloc>();
                    if (bloc.state.position == numSteps - 1) {
                      maybePop(context);
                    } else {
                      bloc.add(const NextPageRequested());
                    }
                  },
                )
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: CloseButton(
                onPressed: () => maybePop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void maybePop(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    }
  }
}

class HowToPlayStepView extends StatelessWidget {
  const HowToPlayStepView({super.key});

  static const steps = <Widget>[
    _Intro(),
    _HandBuilding(),
    _ElementsIntro(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<HowToPlayBloc, HowToPlayState>(
      builder: (context, state) {
        final Widget child;
        if (state.position < steps.length) {
          child = steps[state.position];
        } else {
          child = ElementsWheel(
            allElements: state.elementsWheelState.allElements,
            affectedIndexes: state.elementsWheelState.affectedIndicatorIndexes,
            text: state.elementsWheelState.text(l10n),
          );
        }
        return FadeAnimatedSwitcher(
          duration: transitionDuration,
          child: child,
        );
      },
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: TopDashSpacing.xxlg),
          Image.asset(
            Assets.images.main.path,
            width: 268,
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.md),
            child: HowToPlayStyledText(l10n.howToPlayIntroTitle),
          ),
        ],
      ),
    );
  }
}

class _HandBuilding extends StatelessWidget {
  const _HandBuilding();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: TopDashSpacing.xxlg),
          Image.asset(
            Assets.images.main.path,
            width: 268,
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.md),
            child: HowToPlayStyledText(l10n.howToPlayDeckTitle),
          ),
        ],
      ),
    );
  }
}

class _ElementsIntro extends StatelessWidget {
  const _ElementsIntro();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: TopDashSpacing.lg),
          SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ElementIcon.fire(),
                ),
                Align(
                  alignment: const Alignment(-1, -.1),
                  child: ElementIcon.water(),
                ),
                Align(
                  alignment: const Alignment(1, -.1),
                  child: ElementIcon.air(),
                ),
                Align(
                  alignment: const Alignment(-.6, 1),
                  child: ElementIcon.earth(),
                ),
                Align(
                  alignment: const Alignment(.6, 1),
                  child: ElementIcon.metal(),
                ),
              ],
            ),
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.md),
            child: HowToPlayStyledText(l10n.howToPlayElementsTitle),
          ),
        ],
      ),
    );
  }
}
