import 'package:api/templates/templates.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mustache_template/mustache_template.dart';

const _template = '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/png" href="{{{meta.favIconUrl}}}">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>{{meta.title}}</title>
    <meta name="descripton" content="{{meta.description}}">
    {{{meta.ga}}}
    <meta property="og:title" content="{{meta.title}}">
    <meta property="og:description" content="{{meta.description}}">
    <meta property="og:url" content="{{{meta.shareUrl}}}">
    <meta property="og:image" content="{{{card.image}}}">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.description}}">
    <meta name="twitter:image" content="{{{card.image}}}">
    <meta name="twitter:site" content="@flutterdev">
    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    <style>
      body {
        margin: 0;
        padding: 0;
        font-family: 'Google Sans', sans-serif;
        font-size: 16px;
        line-height: 1.5;
        background-color: #fff;
      }
      main {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .card-img {
        max-width: 400px;
      }
    </style>
  </head>
  <body>
    <main>
      <img class="card-img" src="{{{card.image}}}" alt="{{card.name}}">
    </main>
  </body>
</html>
''';

/// Builds the HMTL page for the sare card link.
String buildShareCardTemplate({
  required Card card,
  required TemplateMetadata meta,
}) {
  return Template(_template).renderString({
    'card': card.toJson(),
    'meta': meta.toJson(),
  });
}
