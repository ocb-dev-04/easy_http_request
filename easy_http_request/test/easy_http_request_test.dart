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

  group('Http request test => ', () {
    test('OnGetOne', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });

    test('OnGetMany', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });

    test('OnPost', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });

    test('OnPut', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });

    test('OnDelete', () async {
      final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
      expect(response, isA<EasyHttpRequestResponse<PostModel>>());
    });
  });
}
