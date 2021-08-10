import 'package:easy_http_request/src/models/easy_http_request_models.dart';
import 'package:easy_http_request/easy_http_request.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';
import 'package:faker/faker.dart';

import 'mock/models/post_mock.dart';

void main() {
  late EasyHttpRequest client;
  late Faker faker;
  late PostModel fakerModel;
  const identifier = 'SingleApiPath';

  setUp(() {
    EasyHttpSettings.initWithSingleApi(
      config: EasyHttpConfig(
        apiPath: 'https://jsonplaceholder.typicode.com',
        identifier: identifier,
        // disable the logger just so you don't see all the requests in the console
        includeLogger: false,
      ),
    );

    client = EasyHttpRequest();
    faker = Faker();
    fakerModel = PostModel(
      id: 1,
      userId: faker.randomGenerator.integer(4000, min: 100),
      title: faker.company.name(),
      body: faker.lorem.sentences(4).join(' '),
    );
  });

  group('Change on board', () {
    test('Change Headers', () async {
      // add headers
      EasyHeadersManager.addHeadersSingleClient(newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
      // update header
      EasyHeadersManager.updateHeadersSingleClient(key: 'jwt', value: 'poiuytrewq');
      // remove header
      EasyHeadersManager.removeHeadersSingleClient(key: 'jwt');
    });

    test('Change Headers Error handler', () async {
      try {
        // add headers
        EasyHeadersManager.addHeadersSingleClient(newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
        // add headers
        EasyHeadersManager.addHeadersSingleClient(newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
        // update header
        EasyHeadersManager.updateHeadersSingleClient(key: 'jwt', value: 'poiuytrewq');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });

  group('On Get Single => ', () {
    test('Compare model data', () async {
      final response = await client.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.getSingle, extraUri: 'posts/1');

      expect(response.modelResponse, isA<PostModel?>());
    });

    test('Compare response (http client)', () async {
      final response = await client.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.getSingle, extraUri: 'posts/1');

      expect(response.completeResponse, isA<Response>());
    });
  });

  group('On Get Collection => ', () {
    test('Compare model data', () async {
      final response = await client.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.getCollection, extraUri: 'posts');

      expect(response.modelResponseAsList, isA<List<PostModel?>>());
    });

    test('Compare response (http client)', () async {
      final response = await client.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.getCollection, extraUri: 'posts');

      expect(response.completeResponse, isA<Response>());
    });
  });

  group('On Post => ', () {
    test('Return model', () async {
      final response = await client.requestWithSinglePATH<PostModel>(model: fakerModel, requestType: EasyHttpType.post, extraUri: 'posts', returnModel: true);

      expect(response.modelResponse, isA<PostModel>());
    });

    test('Compare response (http client)', () async {
      final response = await client.requestWithSinglePATH<PostModel>(model: fakerModel, requestType: EasyHttpType.post, extraUri: 'posts', returnModel: true);

      expect(response.completeResponse, isA<Response>());
    });
  });

  group('On Put => ', () {
    test('Return model', () async {
      final response = await client.requestWithSinglePATH<PostModel>(
          model: fakerModel, requestType: EasyHttpType.put, extraUri: 'posts/${fakerModel.id}', returnModel: true);

      expect(response.modelResponse, isA<PostModel>());
    });

    test('Compare response (http client)', () async {
      final response = await client.requestWithSinglePATH<PostModel>(
          model: fakerModel, requestType: EasyHttpType.put, extraUri: 'posts/${fakerModel.id}', returnModel: true);

      expect(response.completeResponse, isA<Response>());
    });
  });

  group('On Patch => ', () {
    test('Return model', () async {
      final response = await client.requestWithSinglePATH<PostModel>(
          model: fakerModel, requestType: EasyHttpType.patch, extraUri: 'posts/${fakerModel.id}', returnModel: true);

      expect(response.modelResponse, isA<PostModel>());
    });

    test('Compare response (http client)', () async {
      final response = await client.requestWithSinglePATH<PostModel>(
          model: fakerModel, requestType: EasyHttpType.patch, extraUri: 'posts/${fakerModel.id}', returnModel: true);

      expect(response.completeResponse, isA<Response>());
    });
  });

  group('On Delete => ', () {
    test('Compare response (http client)', () async {
      final response = await client.requestWithSinglePATH(model: PostModel(), requestType: EasyHttpType.delete, extraUri: 'posts/${fakerModel.id}');

      expect(response.completeResponse, isA<Response>());
    });
  });
}
