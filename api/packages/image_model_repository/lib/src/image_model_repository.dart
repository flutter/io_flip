import 'dart:math';

/// {@template image_model_repository}
/// Repository providing access image model services.
/// {@endtemplate}
class ImageModelRepository {
  /// {@macro image_model_repository}
  const ImageModelRepository();

  /// Returns the path for an unique generated image.
  Future<String> generateImage() async {
    final rng = Random();
    return 'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_${rng.nextInt(3) + 1}.png?alt=media';
  }
}
