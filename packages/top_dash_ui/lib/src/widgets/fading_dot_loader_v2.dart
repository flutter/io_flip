import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template fading_dot_indicator}
/// A loading indicator with 3 fading dots.
/// {@endtemplate}
class FadingDotLoaderV2 extends StatefulWidget {
  /// {@macro fading_dot_indicator}
  const FadingDotLoaderV2({super.key});

  @override
  State<FadingDotLoaderV2> createState() => _FadingDotLoaderV2State();
}

class _FadingDotLoaderV2State extends State<FadingDotLoaderV2>
    with TickerProviderStateMixin {
  // late final List<AnimationController> animationControllers;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    const length = Duration(milliseconds: 2000);
    // const delay = Duration(milliseconds: 300);
    // animationControllers = [
    //   AnimationController(vsync: this, duration: length),
    //   AnimationController(vsync: this, duration: length),
    //   AnimationController(vsync: this, duration: length),
    // ];

    // for (var i = 0; i < animationControllers.length; i++) {
    //   Future.delayed(
    //     delay * i,
    //     () => animationControllers[i].repeat(reverse: true),
    //   );
    // }
    animationController = AnimationController(vsync: this, duration: length)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AnimatedDot(index: 0, animationController: animationController),
        const SizedBox(width: TopDashSpacing.xs),
        _AnimatedDot(index: 1, animationController: animationController),
        const SizedBox(width: TopDashSpacing.xs),
        _AnimatedDot(index: 2, animationController: animationController),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    required this.animationController,
    required this.index,
  });

  final AnimationController animationController;
  final int index;

  @override
  Widget build(BuildContext context) {
    // final fadeAnimation = Tween<double>(begin: 255, end: 100).animate(
    //   CurvedAnimation(
    //     parent: animationController,
    //     curve: Interval(
    //       begin(),
    //       end(),
    //     ),
    //   ),
    // );

    final sequence = TweenSequence(
      [
        TweenSequenceItem(
          tween: Tween<double>(begin: 255, end: 100),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 100, end: 255),
          weight: 1,
        ),
      ],
    );

    final animation = sequence.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          begin(),
          end(),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final side = animation.value;
        return Container(
          width: TopDashSpacing.lg,
          height: TopDashSpacing.lg,
          decoration: BoxDecoration(
            color: TopDashColors.mainBlue.withAlpha(side.round()),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  double begin() {
    return index / 5;
  }

  double end() {
    return begin() + .6;
  }
}
