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

      await dataLoader.loadPromptTerms((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print('Usage: dart data_loader.dart prompts <projectId> <csv>');
    }
  } else if (subcommand == 'descriptions') {
    if (args.length == 3) {
      final projectId = args[1];
      final csv = args[2];

      final csvFile = File(csv);

      final dbClient = DbClient.initialize(projectId);

      final descriptionsLoader = DescriptionsLoader(
        dbClient: dbClient,
        csv: csvFile,
      );

      await descriptionsLoader.loadDescriptions((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print('Usage: dart data_loader.dart descriptions <projectId> <csv>');
    }
  } else if (subcommand == 'images') {
    if (args.length == 5) {
      final dest = args[1];
      final csv = args[2];
      final image = args[3];
      final cardVariation = int.parse(args.last);

      final csvFile = File(csv);
      final imageFile = File(image);

      final imageLoader = ImageLoader(
        csv: csvFile,
        image: imageFile,
        dest: dest,
        variations: cardVariation,
      );

      await imageLoader.loadImages((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print(
        'Usage: dart data_loader.dart images <dest> <csv> '
        '<images_folder> <card_variation_number>',
      );
    }
  } else if (subcommand == 'validate_images') {
    if (args.length == 5) {
      final imagesFolder = args[1];
      final csv = args[2];
      final variations = args[3];
      final character = args[4];

      final csvFile = File(csv);
      final imagesFolderDirectory = Directory(imagesFolder);

      final descriptionsLoader = CharacterFolderValidator(
        csv: csvFile,
        imagesFolder: imagesFolderDirectory,
        variations: int.parse(variations),
        character: character,
      );

      final missingFiles = await descriptionsLoader.validate((current, total) {
        print('Progress: ($current of $total)');
      });

      print('========== ');
      print('= Result = ');
      print('========== ');
      print('');
      print('Missing files: ${missingFiles.length}');
      for (final missingFile in missingFiles) {
        print(missingFile);
      }
    } else {
      print(
        'Usage: dart bin/data_loader.dart validate_images <images_folder> <csv_file_location.csv> '
        '<card_variation_number> <character>',
      );
    }
  } else if (subcommand == 'generate_tables') {
    if (args.length == 6) {
      final projectId = args[1];
      final imagesFolder = args[2];
      final csv = args[3];
      final variations = args[4];
      final character = args[5];

      final dbClient = DbClient.initialize(projectId);

      final csvFile = File(csv);
      final imagesFolderDirectory = Directory(imagesFolder);

      final generator = CreateImageLookup(
        dbClient: dbClient,
        csv: csvFile,
        imagesFolder: imagesFolderDirectory,
        variations: int.parse(variations),
        character: character,
      );

      await generator.generateLookupTable((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print(
        'Usage: dart bin/data_loader.dart generate_tables <project_id> <images_folder> <csv_file_location.csv> '
        '<card_variation_number> <character>',
      );
    }
  } else if (subcommand == 'normalize') {
    if (args.length == 3) {
      final imagesFolder = args[1];
      final destinationFolder = args[2];

      final imagesFolderDirectory = Directory(imagesFolder);
      final destinationFolderDirectory = Directory(destinationFolder);

      final generator = NormalizeImageNames(
        imagesFolder: imagesFolderDirectory,
        destImagesFolder: destinationFolderDirectory,
      );

      await generator.normalize((current, total) {
        print('Progress: ($current of $total)');
      });
    } else {
      print(
        'Usage: dart bin/data_loader.dart normalize <images_folder> ',
      );
    }
  } else if (subcommand == 'missing_descriptions') {
    if (args.length == 4) {
      final projectId = args[1];
      final csvPath = args[2];
      final character = args[3];

      final csv = File(csvPath);
      final dbClient = DbClient.initialize(projectId);

      final generator = MissingDescriptions(
        dbClient: dbClient,
        csv: csv,
        character: character,
      );

      await generator.checkMissing((__, _) {
        // Progress printing gets in the way on this command.
      });
      print('Done');
    } else {
      print(
        'Usage: dart bin/data_loader.dart missing_descriptions <project_id> <images_folder> <character>',
      );
    }
  } else if (subcommand == 'missing_image_tables') {
    if (args.length == 4) {
      final projectId = args[1];
      final csvPath = args[2];
      final character = args[3];

      final csv = File(csvPath);
      final dbClient = DbClient.initialize(projectId);

      final generator = MissingImageTables(
        dbClient: dbClient,
        csv: csv,
        character: character,
      );

      await generator.checkMissing((__, _) {
        // Progress printing gets in the way on this command.
      });
      print('Done');
    } else {
      print(
        'Usage: dart bin/data_loader.dart missing_image_tables <project_id> <images_folder> <character>',
      );
    }
  } else {
    print('Unknown command: $subcommand');
  }
}
