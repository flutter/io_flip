import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareCardDialog extends StatelessWidget {
  const ShareCardDialog({
    required this.card,
    this.urlLauncher = launchUrlString,
    super.key,
  });

  final AsyncValueSetter<String> urlLauncher;
  final Card card;

  @override
  Widget build(BuildContext context) {
    final shareResource = context.read<ShareResource>();
    return ShareDialog(
      twitterShareUrl: shareResource.twitterShareCardUrl(card.id),
      facebookShareUrl: shareResource.twitterShareCardUrl(card.id),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameCard(
            size: const GameCardSize.md(),
            image: card.image,
            name: card.name,
            description: card.description,
            suitName: card.suit.name,
            power: card.power,
            isRare: card.rarity,
          ),
          const SizedBox(height: IoFlipSpacing.lg),
          Text(
            card.name,
            style: IoFlipTextStyles.mobileH4Light,
          ),
          Text(card.description, style: IoFlipTextStyles.bodyLG),
          const SizedBox(height: IoFlipSpacing.lg),
        ],
      ),
      downloadContent: card,
    );
  }
}
