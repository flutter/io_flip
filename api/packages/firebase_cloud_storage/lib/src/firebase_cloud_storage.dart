import 'dart:io';
import 'dart:typed_data';

import 'package:grpc/grpc.dart' hide Response;
import 'package:http/http.dart';

/// {@template firebase_cloud_storage_upload_failure}
/// Thrown when the upload to Firebase Cloud Storage fails.
/// Contains the error message and the stack trace.
/// {@endtemplate}
class FirebaseCloudStorageUploadFailure implements Exception {
  /// {@macro firebase_cloud_storage_upload_failure}
  const FirebaseCloudStorageUploadFailure(this.message, this.stackTrace);

  /// The error message.
  final String message;

  /// The stack trace.
  final StackTrace stackTrace;

  @override
  String toString() => message;
}

/// A function that builds an [HttpBasedAuthenticator].
typedef AuthenticatorBuilder = Future<HttpBasedAuthenticator> Function(
  List<String> scopes,
);

/// A function that posts a request to a URL.
typedef PostCall = Future<Response> Function(
  Uri uri, {
  Map<String, String>? headers,
  dynamic body,
});

/// {@template firebase_cloud_storage}
/// Allows files to be uploaded to Firebase Cloud Storage.
///
/// Throws a [FirebaseCloudStorageUploadFailure] if the upload fails.
/// {@endtemplate}
class FirebaseCloudStorage {
  /// {@macro firebase_cloud_storage}
  const FirebaseCloudStorage({
    required this.bucketName,
    AuthenticatorBuilder authenticatorBuilder =
        applicationDefaultCredentialsAuthenticator,
    PostCall postCall = post,
  })  : _authenticatorBuilder = authenticatorBuilder,
        _post = postCall;

  final AuthenticatorBuilder _authenticatorBuilder;

  final PostCall _post;

  /// The name of the bucket.
  final String bucketName;

  /// Uploads a file to Firebase Cloud Storage.
  Future<String> uploadFile(Uint8List data, String filename) async {
    final url =
        'https://storage.googleapis.com/upload/storage/v1/b/$bucketName/o?uploadType=media&name=$filename';

    final headers = await _authenticate(url);

    final response = await _post(
      Uri.parse(url),
      body: data,
      headers: {
        ...headers,
        'Content-Type': 'image/png',
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      throw FirebaseCloudStorageUploadFailure(
        response.body,
        StackTrace.current,
      );
    }

    final urlFilename = Uri.encodeComponent(filename);
    return 'https://firebasestorage.googleapis.com/v0/b/$bucketName/o/$urlFilename?alt=media';
  }

  /// Copy a file from one location to another
  Future<void> copyFile(String sourceFile, String destinationFile) async {
    final sourceObject = Uri.encodeComponent(sourceFile);
    final destinationObject = Uri.encodeComponent(destinationFile);

    final url =
        'https://storage.googleapis.com/storage/v1/b/$bucketName/o/$sourceObject/copyTo/b/$bucketName/o/$destinationObject';

    final headers = await _authenticate(url);

    final response = await _post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode != HttpStatus.ok) {
      throw FirebaseCloudStorageUploadFailure(
        response.body,
        StackTrace.current,
      );
    }
  }

  Future<Map<String, String>> _authenticate(String uri) async {
    final delegate = await _authenticatorBuilder([
      'https://www.googleapis.com/auth/storage',
    ]);

    final metadata = <String, String>{};
    await delegate.authenticate(metadata, uri);

    return metadata;
  }
}
