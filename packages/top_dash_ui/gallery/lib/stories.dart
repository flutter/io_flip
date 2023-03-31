import 'package:dashbook/dashbook.dart';
import 'package:gallery/colors/app_colors_story.dart';
import 'package:gallery/spacing/app_spacing_story.dart';
import 'package:gallery/typography/typography_story.dart';
import 'package:gallery/widgets/widgets.dart';

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
      );
}
