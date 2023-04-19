import 'package:dashbook/dashbook.dart';
import 'package:gallery/colors/app_colors_story.dart';
import 'package:gallery/spacing/app_spacing_story.dart';
import 'package:gallery/typography/typography_story.dart';
import 'package:gallery/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

final _controller = AnimatedCardController();

void addStories(Dashbook dashbook) {
  dashbook.storiesOf('AppSpacing').add(
        'default',
        (_) => const AppSpacingStory(),
      );

  dashbook.storiesOf('AppColors').add(
        'default',
        (_) => const AppColorsStory(),
      );

  dashbook.storiesOf('Typography').add(
        'default',
        (_) => const TypographyStory(),
      );

  dashbook.storiesOf('Layouts').add(
        'Responsive Layout',
        (_) => const ResponsiveLayoutStory(),
      );

  dashbook.storiesOf('Buttons').add(
        'Rounded Button',
        (_) => const RoundedButtonStory(),
      );

  dashbook.storiesOf('Loaders').add(
        'Fading Dots',
        (_) => const FadingDotLoaderStory(),
      );

  dashbook.storiesOf('Shaders').add(
        'Foil Shader',
        (_) => const FoilShaderStory(),
      );

  dashbook.storiesOf('Flip Countdown').add(
        'Flip Countdown',
        (_) => const FlipCountdownStory(),
      );

  dashbook
      .storiesOf('Cards')
      .add(
        'Game Card',
        (_) => const GameCardStory(),
      )
      .add(
        'Game Card Overlay',
        (_) => const GameCardOverlayStory(),
      )
      .add(
        'Flipped Game Card',
        (_) => const FlippedGameCardStory(),
      )
      .add(
    'Animated Card',
    (ctx) {
      ctx
        ..action('Small Flip', (_) => _controller.run(smallFlipAnimation))
        ..action('Big Flip', (_) => _controller.run(bigFlipAnimation))
        ..action('Jump', (_) => _controller.run(jumpAnimation))
        ..action('Knock Out', (_) => _controller.run(knockOutAnimation))
        ..action(
          'Flip and Jump',
          (_) => _controller
              .run(smallFlipAnimation)
              .then((_) => _controller.run(jumpAnimation)),
        )
        ..action('Attack', (_) => _controller.run(attackAnimation));

      return AnimatedCardStory(controller: _controller);
    },
  );
}
