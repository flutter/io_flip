import 'package:api_client/api_client.dart';

/// {@template share_resource}
/// An api resource for the public sharing API.
/// {@endtemplate}
class ShareResource {
  /// {@macro share_resource}
  ShareResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final _tweetContent =
      'Check out my AI powered team of heroes created in the #IOFlipGame. '
      'See you at #GoogleIO23!';

  String _twitterShareUrl(String text) =>
      'https://twitter.com/intent/tweet?text=$text';

  String _facebookShareUrl(String shareUrl) =>
      'https://www.facebook.com/sharer.php?u=$shareUrl';

  String _encode(List<String> content) =>
      content.join('%0a').replaceAll(' ', '%20');

  /// Returns the url to share a tweet for the specified [cardId].
  String twitterShareCardUrl(String cardId) {
    final cardUrl = _apiClient.shareCardUrl(cardId);
    final content = [
      _tweetContent,
      cardUrl,
    ];
    return _twitterShareUrl(_encode(content));
  }

  /// Returns the url to share a tweet for the specified [deckId].
  String twitterShareHandUrl(String deckId, {bool isWinningHand = false}) {
    final handUrl = _apiClient.shareHandUrl(deckId);
    final content = [
      _tweetContent,
      handUrl,
    ];
    return _twitterShareUrl(_encode(content));
  }

  /// Returns the url to share a facebook post for the specified [cardId].
  String facebookShareCardUrl(String cardId) {
    final cardUrl = _apiClient.shareCardUrl(cardId);
    return _facebookShareUrl(cardUrl);
  }

  /// Returns the url to share a facebook post for the specified [deckId].
  String facebookShareHandUrl(String deckId) {
    final handUrl = _apiClient.shareHandUrl(deckId);
    return _facebookShareUrl(handUrl);
  }

  /// Returns the game url.
  String shareGameUrl() {
    return _apiClient.shareGameUrl();
  }
}
