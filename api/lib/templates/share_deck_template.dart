import 'package:mustache_template/mustache_template.dart';

const _template = '''
      <img
        src="{{{handImage}}}"
      />
      <div class="hand-section">
        <h3 class="initials">{{initials}}</h3>
        <h4 class="streak">{{streak}} win streak!</h4>
      </div>
''';

/// Builds the HMTL page for the sare card link.
String buildHandContent({
  required String handImage,
  required String initials,
  required String streak,
}) {
  return Template(_template).renderString({
    'handImage': handImage,
    'initials': initials,
    'streak': streak,
  });
}
