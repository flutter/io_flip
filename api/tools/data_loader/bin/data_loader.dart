// ignore_for_file: avoid_print

import 'dart:io';

import 'package:data_loader/data_loader.dart';
import 'package:db_client/db_client.dart';
import 'package:prompt_repository/prompt_repository.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('No command specified');
    return;
  }

  final subcommand = args.first;

  if (subcommand == 'prompts') {
    if (args.length == 3) {
      final projectId = args[1];
      final csv = args[2];

      final csvFile = File(csv);

      final dbClient = DbClient.initialize(projectId);
      final promptRepository = PromptRepository(
        dbClient: dbClient,
      );

      final dataLoader = DataLoader(
        promptRepository: promptRepository,
        csv: csvFile,
      );

      await dataLoader.loadPrompties((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print('Usage: dart data_loader.dart prompts <projectId> <csv>');
    }
  } else if (subcommand == 'images') {
    if (args.length == 4) {
      final dest = args[1];
      final csv = args[2];
      final image = args.last;

      final csvFile = File(csv);
      final imageFile = File(image);

      final imageLoader = ImageLoader(
        csv: csvFile,
        image: imageFile,
        dest: dest,
      );

      await imageLoader.loadImages((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print(
        'Usage: dart data_loader.dart images <dest> <csv> '
        '<images_folder>',
      );
    }
  } else {
    print('Unknown command: $subcommand');
  }
}
