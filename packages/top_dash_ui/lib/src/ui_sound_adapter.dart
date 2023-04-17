/// Function definition for a function that plays a sound for buttons.
typedef PlayButtonSound = void Function();

/// {@template ui_sound_adapater}
/// An adapter used by the top dash ui package to play sounds.
///
/// This adapter should be provided on top of the application tree
/// in order for its widgets to have access to it.
///
/// {@endtemplate}
class UISoundAdaptater {
  /// {@macro ui_sound_adapater}
  const UISoundAdaptater({
    required this.playButtonSound,
  });

  /// The function that plays a sound for buttons.
  final PlayButtonSound playButtonSound;
}
