import 'dart:io';

import 'package:image/image.dart';

void main() async {
  final illustrationCmd = Command()..decodeImageFile('assets/dash_1.png');
  final frameCmd = Command()..decodeImageFile('assets/card-fire.png');

  final fontZip = File('assets/GoogleSans-Regular.ttf.zip').readAsBytesSync();

  final fontPower = BitmapFont.fromZip(fontZip)..size = 60;
  final fontDescription = BitmapFont.fromZip(fontZip);

  final compositionCommand = Command()
    ..createImage(width: 654, height: 870)
    ..compositeImage(illustrationCmd, dstX: 0, dstY: 0, dstW: 654, dstH: 870)
    ..compositeImage(frameCmd)
    ..drawString(
      'Hello World',
      font: fontDescription,
      x: 50,
      y: 810,
      color: ColorRgb8(0, 0, 0),
    )
    ..drawString(
      '70',
      font: fontPower,
      x: 600,
      y: 20,
      color: ColorRgb8(0, 0, 0),
    )
    ..encodePng()
    ..encodePngFile('output.png');

  await compositionCommand.execute();
}
