import 'dart:math';

import 'package:game_domain/game_domain.dart';
import 'package:prompt_repository/prompt_repository.dart';

/// {@template image_result}
/// Image result model.
/// {@endtemplate}
class ImageResult {
  /// {@macro image_result}
  const ImageResult({
    required this.character,
    required this.characterClass,
    required this.location,
    required this.url,
  });

  /// The character of the image.
  final String character;

  /// The character class of the image.
  final String characterClass;

  /// The location of the image.
  final String location;

  /// The url of the image.
  final String url;
}

/// {@template image_model_repository}
/// Repository providing access image model services.
/// {@endtemplate}
class ImageModelRepository {
  /// {@macro image_model_repository}
  ImageModelRepository({
    required String imageHost,
    required PromptRepository promptRepository,
    String? urlParams,
    Random? rng,
  })  : _imageHost = imageHost,
        _promptRepository = promptRepository,
        _urlParams = urlParams {
    _rng = rng ?? Random();
  }

  final String _imageHost;
  final String? _urlParams;
  final PromptRepository _promptRepository;
  late final Random _rng;

  String _normalizeTerm(String value) {
    return value.toLowerCase().replaceAll(' ', '_');
  }

  /// Builds the url based on the provided parameters.
  ImageResult assembleUrl({
    required String character,
    required String characterClass,
    required String location,
    required int variation,
  }) {
    final characterUrl = _normalizeTerm(character);
    final characterClassUrl = _normalizeTerm(characterClass);
    final locationUrl = _normalizeTerm(location);

    return ImageResult(
      character: character,
      characterClass: characterClass,
      location: location,
      url: '$_imageHost${characterUrl}_$characterClassUrl'
          '_${locationUrl}_$variation.png${_urlParams ?? ''}',
    );
  }

  /// Returns the path for an unique generated image.
  Future<List<ImageResult>> generateImages({
    required String characterClass,
    required int variationsAvailable,
    required int deckSize,
  }) async {
    final [characters, locations] = await Future.wait([
      _promptRepository.getPromptTermsByType(
        PromptTermType.character,
      ),
      _promptRepository.getPromptTermsByType(
        PromptTermType.location,
      )
    ]);

    final urls = <ImageResult>[];
    final charactersPerDeck = deckSize ~/ characters.length;

    for (var i = 0; i < charactersPerDeck; i++) {
      for (final character in characters) {
        final location = locations[_rng.nextInt(locations.length)];
        final variation = _rng.nextInt(variationsAvailable);

        urls.add(
          assembleUrl(
            character: character.term,
            characterClass: characterClass,
            location: location.term,
            variation: variation,
          ),
        );
      }
    }

    return urls;
  }
}
