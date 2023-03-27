import 'package:api/templates/templates.dart';
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
    <meta property="og:image" content="{{{meta.image}}}">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.description}}">
    <meta name="twitter:image" content="{{{meta.image}}}">
    <meta name="twitter:site" content="@flutterdev">
    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Google+Sans+Text:400,500" rel="stylesheet">
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
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      h3 {
        font-family: 'Google Sans';
        font-style: normal;
        font-weight: 500;
        font-size: 24px;
        line-height: 32px;
        text-align: center;
        color: #202124;
      }

      h3.initials {
        font-family: 'Google Sans';
        font-style: normal;
        font-weight: 500;
        font-size: 36px;
        line-height: 48px;

        display: flex;
        align-items: center;
        text-align: center;
        letter-spacing: -2px;
        color: #0056D6;
        padding: 0px;
        margin: 0px;
      }

      h4.streak {
        font-family: 'Google Sans';
        font-style: normal;
        font-weight: 500;
        font-size: 18px;
        line-height: 24px;
        margin-top: 0px;
        padding: 0px;
        display: flex;
        align-items: center;
        text-align: center;
        letter-spacing: -0.25px;
        color: #0056D6;
      }

      p {
        font-family: 'Google Sans Text';
        font-style: normal;
        font-weight: 400;
        font-size: 16px;
        line-height: 24px;
        text-align: center;
        color: #202124;
        maring: 8px 32px;
      }

      img {
        max-width: 400px;
        margin-bottom: 32px;
      }

      .btn {
        padding: 8px 24px;
        background: #A1C6FF;
        box-shadow: 3px 4px 0px #000000;
        border: 2px solid #202124;
        border-radius: 100px;

        font-family: 'Google Sans';
        font-style: normal;
        font-weight: 500;
        font-size: 16px;
        line-height: 24px;

        display: flex;
        align-items: center;
        text-align: center;
        letter-spacing: 0.25px;
        text-transform: uppercase;
        text-decoration: none;

        color: #202124;
      }

      .hand-section {
        display: flex;
        flex-direction: column;
        align-items: center;
      }
    </style>
  </head>
  <body>
    <main>
      {{{content}}}
      <h3>{{header}}</h3>
      <p>Play I/O Bash and use AI to create cards and compete against players from around the globe.</p>
      <a class="btn" href="{{{meta.gameUrl}}}">
        PLAY NOW
      </a>
    </main>
  </body>
</html>
''';

/// Builds the HMTL page for the sare card link.
String buildShareTemplate({
  required String content,
  required String header,
  required TemplateMetadata meta,
}) {
  return Template(_template).renderString({
    'content': content,
    'header': header,
    'meta': meta.toJson(),
  });
}
