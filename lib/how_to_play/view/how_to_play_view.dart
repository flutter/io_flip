import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class HowToPlayView extends StatelessWidget {
  const HowToPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSteps = context.select<HowToPlayBloc, int>(
      (bloc) => bloc.state.totalSteps,
    );
    final selectedPageIndex = context.select<HowToPlayBloc, int>(
      (bloc) => bloc.state.position,
    );

    return Container(
      constraints: const BoxConstraints.expand(width: 400, height: 584),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: TopDashSpacing.xlg,
                ),
                constraints: const BoxConstraints(maxWidth: 220),
                child: Row(
                  key: const Key('how_to_play_page_indicator'),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    totalSteps,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton.icon(
                    const Icon(Icons.arrow_back),
                    onPressed: () {
                      final bloc = context.read<HowToPlayBloc>();
                      if (bloc.state.position == 0) {
                        maybePop(context);
                      } else {
                        bloc.add(const PreviousPageRequested());
                      }
                    },
                  ),
                  const SizedBox(width: TopDashSpacing.md),
                  RoundedButton.icon(
                    const Icon(Icons.arrow_forward),
                    onPressed: () {
                      final bloc = context.read<HowToPlayBloc>();
                      if (bloc.state.position == totalSteps - 1) {
                        maybePop(context);
                      } else {
                        bloc.add(const NextPageRequested());
                      }
                    },
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const initialSteps = HowToPlayState.initialSteps;
    const finalSteps = HowToPlayState.finalSteps;

    return BlocBuilder<HowToPlayBloc, HowToPlayState>(
      builder: (context, state) {
        final Widget child;
        final Key key;
        if (state.position < initialSteps.length) {
          key = ValueKey(state.position);
          child = initialSteps[state.position];
        } else if (state.position <
            initialSteps.length + state.wheelSuits.length) {
          key = const ValueKey('suits_wheel');
          child = SuitsWheel(
            suits: state.wheelSuits,
            affectedIndexes: state.affectedIndicatorIndexes,
            text: state.wheelSuits.first.text(l10n),
          );
        } else {
          key = ValueKey(state.position);
          final position =
              state.position - (initialSteps.length + state.wheelSuits.length);
          child = finalSteps[position];
        }
        return FadeAnimatedSwitcher(
          duration: transitionDuration,
          child: SingleChildScrollView(
            key: key,
            child: child,
          ),
        );
      },
    );
  }
}

class HowToPlayIntro extends StatelessWidget {
  const HowToPlayIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
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
    );
  }
}

class HowToPlayHandBuilding extends StatelessWidget {
  const HowToPlayHandBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
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
    );
  }
}

class HowToPlaySuitsIntro extends StatelessWidget {
  const HowToPlaySuitsIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const scale = .69;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.lg),
        SizedBox(
          height: 220,
          width: 220,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SuitIcon.fire(scale: scale),
              ),
              Align(
                alignment: const Alignment(-1, -.1),
                child: SuitIcon.water(scale: scale),
              ),
              Align(
                alignment: const Alignment(1, -.1),
                child: SuitIcon.air(scale: scale),
              ),
              Align(
                alignment: const Alignment(-.6, 1),
                child: SuitIcon.earth(scale: scale),
              ),
              Align(
                alignment: const Alignment(.6, 1),
                child: SuitIcon.metal(scale: scale),
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
    );
  }
}

class HowToPlaySummary extends StatelessWidget {
  const HowToPlaySummary({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxlg),
        Image.asset(
          Assets.images.main.path,
          width: 268,
        ),
        const SizedBox(height: TopDashSpacing.xxlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.md),
          child: HowToPlayStyledText(l10n.howToPlaySummaryTitle),
        ),
      ],
    );
  }
}
