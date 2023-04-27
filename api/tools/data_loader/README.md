# Data Loader

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Dart tool that feed data into the Database

## Installation 💻

**❗ In order to start using Data Loader you must have the [Dart SDK][dart_install_link] installed on your machine.**

Add `data_loader` to your `pubspec.yaml`:

```yaml
dependencies:
  data_loader:
```

Install it:

```sh
dart pub get
```

## Run the tool

This tool is used to insert data in firebase,

It have two commands, one to load the prompt terms in the firestore database of the project, and one to load placeholder images in firestore cloud storage for those prompts.

Download the prompts CSV which must have the following format:

```
'Character,Class,Power,Location,'
'Dash,Alien,Banjos,City,'
...
```

### Loading prompts

Run:

```
dart bin/data_loader.dart prompts projectId csv_file_location.csv
```

It uses the gcloud default admin app for auth, so you must have it properly configured
in your machine before running it.

### Loading images placeholder

The images placeholder command will create the expected file structure in a `destination_folder`
which should then be uploaded to firebase cloud storage.

In order to do so, run:

```
dart bin/data_loader.dart images destination_folder csv_file_location.csv placeholder_image_path <number_of_cards_in_deck>
```

Then, inside the `destination_folder`, run:

```
gcloud storage cp --gzip-local-all --recursive . gs://<bucket-id>
```

Similar to the prompts command, you need to have the gcloud cli properly configured
and authenticated.
