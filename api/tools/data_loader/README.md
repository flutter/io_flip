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

This tool is used to insert the prompt terms in the firestore database of the project.

It uses the gcloud default admin app for auth, so you must have it properly configured
in your machine before running it.

Then, download the CSV with the prompts and run:

```
dart bin/data_loader.dart projectId csv_file_location.csv
```
