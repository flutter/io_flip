import 'dart:math';

import 'package:game_domain/game_domain.dart';
import 'package:prompt_repository/prompt_repository.dart';

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

  /// Builds the url based on the provided parameters.
  String assembleUrl({
    required String character,
    required String characterClass,
    required String location,
    required int variation,
  }) {
    return '$_imageHost${character}_$characterClass'
        '_${location}_$variation.png${_urlParams ?? ''}';
  }

  /// Returns the path for an unique generated image.
  Future<List<String>> generateImages({
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

    final urls = <String>[];
    final charactersPerDeck = deckSize ~/ characters.length;

    for (var i = 0; i < charactersPerDeck; i++) {
      for (final character in characters) {
        final location = locations[_rng.nextInt(locations.length)];
        final variation = _rng.nextInt(variationsAvailable);

        urls.add(
          assembleUrl(
            character: character.term.toLowerCase(),
            characterClass: characterClass.toLowerCase(),
            location: location.term.toLowerCase(),
            variation: variation,
          ),
        );
      }
    }

    return urls;
  }
}
