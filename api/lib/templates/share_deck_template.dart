import 'package:mustache_template/mustache_template.dart';

const _template = '''
      <img
        src="{{{handImage}}}"
      />
      <div class="hand-section">
        {{#initials}}
        <h3 class="initials">{{initials}}</h3>
        {{/initials}}
        {{#streak}}
        <h4 class="streak">{{streak}} win streak!</h4>
        {{/streak}}
      </div>
''';

/// Builds the HTML page for the share card link.
String buildHandContent({
  required String handImage,
  required String? initials,
  required String? streak,
}) {
  return Template(_template).renderString({
    'handImage': handImage,
    'initials': initials,
    'streak': streak,
  });
}
