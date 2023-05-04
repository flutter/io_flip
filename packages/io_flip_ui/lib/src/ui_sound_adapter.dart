/// Function definition for a function that plays a sound for buttons.
typedef PlayButtonSound = void Function();

/// {@template ui_sound_adapter}
/// An adapter used by the io_flip_ui package to play sounds.
///
/// This adapter should be provided on top of the application tree
/// in order for its widgets to have access to it.
///
/// {@endtemplate}
class UISoundAdapter {
  /// {@macro ui_sound_adapter}
  const UISoundAdapter({
    required this.playButtonSound,
  });

  /// The function that plays a sound for buttons.
  final PlayButtonSound playButtonSound;
}
