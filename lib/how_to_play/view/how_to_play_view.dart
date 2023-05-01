import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/utils/utils.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

const _imageHeight = 184.0;

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 400,
          child: HowToPlayStepView(),
        ),
        Container(
          padding: const EdgeInsets.only(
            top: TopDashSpacing.lg * 2,
            bottom: TopDashSpacing.lg,
          ),
          constraints: const BoxConstraints(maxWidth: 224),
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
                      ? TopDashColors.seedYellow
                      : TopDashColors.seedGrey70,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TopDashSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton.icon(
                Icons.arrow_back,
                onPressed: () {
                  final bloc = context.read<HowToPlayBloc>();
                  if (bloc.state.position == 0) {
                    context.maybePop();
                  } else {
                    bloc.add(const PreviousPageRequested());
                  }
                },
              ),
              const SizedBox(width: TopDashSpacing.md),
              RoundedButton.icon(
                Icons.arrow_forward,
                onPressed: () {
                  final bloc = context.read<HowToPlayBloc>();
                  if (bloc.state.position == totalSteps - 1) {
                    context.maybePop();
                  } else {
                    bloc.add(const NextPageRequested());
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HowToPlayStepView extends StatelessWidget {
  const HowToPlayStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const steps = HowToPlayState.steps;

    return BlocBuilder<HowToPlayBloc, HowToPlayState>(
      builder: (context, state) {
        final Widget child;
        final Key key;
        if (state.position < steps.length) {
          key = ValueKey(state.position);
          child = steps[state.position];
        } else {
          key = const ValueKey('suits_wheel');
          child = SuitsWheel(
            suits: state.wheelSuits,
            affectedIndexes: state.affectedIndicatorIndexes,
            text: state.wheelSuits.first.text(l10n),
          );
        }
        return FadeAnimatedSwitcher(
          duration: transitionDuration,
          child: Container(
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
      mainAxisSize: MainAxisSize.min,
      children: [
        IoFlipLogo(height: _imageHeight),
        const SizedBox(height: TopDashSpacing.xxlg),
        Flexible(
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO(willhlas): replace with card fan.
        Image.asset(
          Assets.images.main.path,
          height: _imageHeight,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _imageHeight,
          width: _imageHeight,
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
