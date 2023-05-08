// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/src/widgets/damages/dual_animation.dart';

void main() {
  group('ReverseRRectClipper', () {
    group('shouldReclip', () {
      test('returns true for a different RRect', () {
        final oldClipper = ReverseRRectClipper(
          RRect.fromRectAndRadius(
            Offset.zero & Size(50, 200),
            Radius.circular(50),
          ),
        );
        final newClipper = ReverseRRectClipper(
          RRect.fromRectAndRadius(
            Offset.zero & Size(50, 150),
            Radius.circular(50),
          ),
        );

        expect(newClipper.shouldReclip(oldClipper), isTrue);
      });

      test('returns false for the same RRect', () {
        final oldClipper = ReverseRRectClipper(
          RRect.fromRectAndRadius(
            Offset.zero & Size(50, 200),
            Radius.circular(50),
          ),
        );
        final newClipper = ReverseRRectClipper(
          RRect.fromRectAndRadius(
            Offset.zero & Size(50, 200),
            Radius.circular(50),
          ),
        );

        expect(newClipper.shouldReclip(oldClipper), isFalse);
      });
    });
  });
}
