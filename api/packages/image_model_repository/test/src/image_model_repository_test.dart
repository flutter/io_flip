// ignore_for_file: prefer_const_constructors
import 'package:image_model_repository/image_model_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ImageModelRepository', () {
    test('can be instantiated', () {
      expect(ImageModelRepository(), isNotNull);
    });

    test('returns a valid image path', () async {
      final repository = ImageModelRepository();
      final path = await repository.generateImage();
      expect(
        path,
        isA<String>(),
      );
    });
  });
}
