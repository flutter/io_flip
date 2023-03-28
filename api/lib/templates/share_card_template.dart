import 'package:game_domain/game_domain.dart';
import 'package:mustache_template/mustache_template.dart';

const _template = '''
      <img
        class="card-img"
        src="{{{card.image}}}"
        alt="{{card.name}}"
      >
''';

/// Builds the HMTL page for the sare card link.
String buildShareCardContent({required Card card}) {
  return Template(_template).renderString({
    'card': card.toJson(),
  });
}
