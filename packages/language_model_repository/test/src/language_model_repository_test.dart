// ignore_for_file: prefer_const_constructors
import 'package:language_model_repository/language_model_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LanguageModelRepository', () {
    test('can be instantiated', () {
      expect(LanguageModelRepository(), isNotNull);
    });

    test('generateCardName returns an unique name', () async {
      final repository = LanguageModelRepository();
      expect(
        await repository.generateCardName(),
        isA<String>(),
      );
    });

    test('generateFlavorText returns an unique text', () async {
      final repository = LanguageModelRepository();
      expect(
        await repository.generateFlavorText(),
        isA<String>(),
      );
    });
  });
}
