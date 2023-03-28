import 'package:json_annotation/json_annotation.dart';

part 'template_metadata.g.dart';

/// {@template metadata}
/// Metadata for templates.
/// {@endtemplate}
@JsonSerializable()
class TemplateMetadata {
  /// {@macro metadata}
  const TemplateMetadata({
    required this.title,
    required this.description,
    required this.shareUrl,
    required this.favIconUrl,
    required this.ga,
    required this.gameUrl,
    required this.image,
  });

  /// The title of the page.
  final String title;

  /// The description of the page.
  final String description;

  /// The share url.
  final String shareUrl;

  /// The favicon url.
  final String favIconUrl;

  /// The Google Analytics code.
  final String ga;

  /// The game url.
  final String gameUrl;

  /// The image url.
  final String image;

  /// Returns this instance as a json.
  Map<String, dynamic> toJson() {
    return _$TemplateMetadataToJson(this);
  }
}
