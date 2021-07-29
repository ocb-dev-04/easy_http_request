import 'package:dio/dio.dart';
import 'package:easy_http_request/core/services/http_request.dart';
import 'package:easy_http_request/data/easy_http_request_models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/post_mock.dart';

void main() {
  late EasyHttpRequest client;
  setUp(() {
    client = EasyHttpRequest();
    client.init(
        config: HttpConfigData(
      baseApi: 'https://jsonplaceholder.typicode.com',
      includeLogger: false, // disable logger just so you don't see all requests in console
    ));
  });

  group('On GetOne => ', () {
    test('compare model', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });

    test('compare model data', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response.modelResponse, isA<PostModel?>());
    });

    test('compare response (http client)', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response.completeResponse, isA<Response>());
    });
  });

  group('On GetMany => ', () {
    test('compare model', () async {
      final response = await client.onGetMany<PostModel>(extraUri: 'posts', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });

    test('compare model data', () async {
      final response = await client.onGetMany<PostModel>(extraUri: 'posts', model: PostModel());
      expect(response.modelResponseAsList, isA<List<PostModel?>>());
    });
  });

  group('On Post => ', () {
    test('OnPost', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });
  });

  group('On Put => ', () {
    test('OnPut', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });
  });

  group('On Delete => ', () {
    test('OnDelete', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });
  });
}
