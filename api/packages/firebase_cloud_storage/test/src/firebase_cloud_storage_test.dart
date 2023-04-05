// ignore_for_file: prefer_const_constructors, one_member_abstracts
import 'dart:typed_data';

import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:grpc/grpc.dart' hide Response;
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpBasedAuthenticator extends Mock
    implements HttpBasedAuthenticator {
  @override
  Future<void> authenticate(Map<String, String> metadata, String uri) async {
    metadata['mock_header'] = 'mock_value';
  }
}

class _MockResponse extends Mock implements Response {}

abstract class __HttpClient {
  Future<Response> post(Uri uri, {Map<String, String>? headers, dynamic body});
}

class _MockHttpClient extends Mock implements __HttpClient {}

void main() {
  group('FirebaseCloudStorage', () {
    late FirebaseCloudStorage firebaseCloudStorage;
    late HttpBasedAuthenticator authenticator;
    late Response response;
    late __HttpClient httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      authenticator = _MockHttpBasedAuthenticator();
      response = _MockResponse();
      when(() => response.statusCode).thenReturn(200);

      httpClient = _MockHttpClient();
      when(
        () => httpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any<dynamic>(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      firebaseCloudStorage = FirebaseCloudStorage(
        bucketName: 'bucketName',
        authenticatorBuilder: (_) async => authenticator,
        postCall: httpClient.post,
      );
    });

    test('can be instantiated', () {
      expect(
        FirebaseCloudStorage(bucketName: ''),
        isNotNull,
      );
    });

    test('returns the uploaded object url', () async {
      final url = await firebaseCloudStorage.updloadFile(
        Uint8List(0),
        'filename',
      );

      expect(
        url,
        equals(
          'https://firebasestorage.googleapis.com/v0/b/bucketName/o/filename?alt=media',
        ),
      );
    });

    test('correctly encode complex urls', () async {
      final url = await firebaseCloudStorage.updloadFile(
        Uint8List(0),
        'share/filename',
      );

      expect(
        url,
        equals(
          'https://firebasestorage.googleapis.com/v0/b/bucketName/o/share%2Ffilename?alt=media',
        ),
      );
    });

    test('makes the correct request', () async {
      await firebaseCloudStorage.updloadFile(
        Uint8List(0),
        'filename',
      );

      verify(
        () => httpClient.post(
          Uri.parse(
            'https://storage.googleapis.com/upload/storage/v1/b/bucketName/o?uploadType=media&name=filename',
          ),
          headers: {
            'mock_header': 'mock_value',
            'Content-Type': 'image/png',
          },
          body: Uint8List(0),
        ),
      );
    });

    test(
      'throws FirebaseCloudStorageUploadFailure when the request fails',
      () async {
        when(() => response.statusCode).thenReturn(500);
        when(() => response.body).thenReturn('Error');

        await expectLater(
          () => firebaseCloudStorage.updloadFile(
            Uint8List(0),
            'filename',
          ),
          throwsA(
            isA<FirebaseCloudStorageUploadFailure>().having(
              (e) => e.toString(),
              'message',
              equals('Error'),
            ),
          ),
        );
      },
    );
  });
}
