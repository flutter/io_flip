import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/styled_text.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  factory HowToPlayPage.routeBuilder(_, __) {
    return const HowToPlayPage(
      key: Key('how_to_play'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    const pages = <Widget>[
      _Intro(),
      _HandBuilding(),
      _ElementsIntro(),
      _ElementsFire(),
      _ElementsAir(),
      _ElementsMetal(),
      _ElementsEarth(),
      _ElementsWater(),
    ];

    return Scaffold(
      backgroundColor: TopDashColors.seedScrim,
      body: Center(
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
                  Expanded(
                    child: PageView(
                      scrollBehavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      controller: pageController,
                      children: pages,
                    ),
                  ),
                  RoundedButton.icon(
                    const Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (pageController.page == pages.length - 1) {
                        maybePop(context);
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease,
                        );
                      }
                    },
                  )
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: CloseButton(
                  onPressed: () {
                    maybePop(context);
                  },
                ),
              ),
            ],
          ),
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

class _Intro extends StatelessWidget {
  const _Intro();

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
          child: _CustomText(l10n.howToPlayIntroTitle),
        ),
      ],
    );
  }
}

class _HandBuilding extends StatelessWidget {
  const _HandBuilding();

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
          child: _CustomText(l10n.howToPlayDeckTitle),
        ),
      ],
    );
  }
}

class _ElementsIntro extends StatelessWidget {
  const _ElementsIntro();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
          child: _CustomText(l10n.howToPlayElementsTitle),
        ),
      ],
    );
  }
}

class _ElementsFire extends StatelessWidget {
  const _ElementsFire();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxxlg),
        _CustomText(l10n.howToPlayElementsFireTitle),
      ],
    );
  }
}

class _ElementsAir extends StatelessWidget {
  const _ElementsAir();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxxlg),
        _CustomText(l10n.howToPlayElementsAirTitle),
      ],
    );
  }
}

class _ElementsMetal extends StatelessWidget {
  const _ElementsMetal();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxxlg),
        _CustomText(l10n.howToPlayElementsMetalTitle),
      ],
    );
  }
}

class _ElementsEarth extends StatelessWidget {
  const _ElementsEarth();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxxlg),
        _CustomText(l10n.howToPlayElementsEarthTitle),
      ],
    );
  }
}

class _ElementsWater extends StatelessWidget {
  const _ElementsWater();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: TopDashSpacing.xxxlg),
        _CustomText(l10n.howToPlayElementsWaterTitle),
      ],
    );
  }
}

class _CustomText extends StatelessWidget {
  const _CustomText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: text,
      style: textStyle(context),
      tags: textTags(context),
      textAlign: TextAlign.center,
    );
  }

  bool isScreenSmall(BuildContext context) =>
      MediaQuery.of(context).size.width < TopDashBreakpoints.medium;

  TextStyle textStyle(BuildContext context) {
    return isScreenSmall(context)
        ? TopDashTextStyles.headlineMobileH4Light
        : TopDashTextStyles.headlineH4Light;
  }

  Map<String, StyledTextTagBase> textTags(BuildContext context) {
    return {
      'bold': StyledTextTag(
        style: isScreenSmall(context)
            ? TopDashTextStyles.headlineMobileH4
            : TopDashTextStyles.headlineH4,
      ),
      'yellow': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedYellow),
      ),
      'lightblue': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedPaletteLightBlue80),
      ),
      'green': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedGreen),
      ),
      'red': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedRed),
      ),
      'blue': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedBlue),
      ),
    };
  }
}
