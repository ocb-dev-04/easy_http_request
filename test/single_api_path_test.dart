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
    EasyHttpSettings.initWithSigleApi(
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
      try {
        // add headers
        EasyHeadersManager.addHeadersSingleClient(newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
        // update header
        EasyHeadersManager.updateHeadersSingleClient(key: 'jwt', value: 'poiuytrewq');
        // remove header
        EasyHeadersManager.removeHeadersSingleClient(key: 'jwt');
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Get Single => ', () {
    test('Compare model data', () async {
      try {
        final response = await client.requestWithSinglePATH<PostModel>(
          model: PostModel(),
          requestType: EasyHttpType.getSingle,
          extraUri: 'posts/1',
        );
        expect(response.modelResponse, isA<PostModel?>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.requestWithSinglePATH<PostModel>(
          model: PostModel(),
          requestType: EasyHttpType.getSingle,
          extraUri: 'posts/1',
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Get Collection => ', () {
    test('Compare model data', () async {
      try {
        final response = await client.onGetCollection<PostModel>(
          model: PostModel(),
          extraUri: 'posts',
        );
        expect(response.modelResponseAsList, isA<List<PostModel?>>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.onGetCollection<PostModel>(
          model: PostModel(),
          extraUri: 'posts',
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Post => ', () {
    test('Return model', () async {
      try {
        final response = await client.onPost<PostModel>(
          model: fakerModel,
          extraUri: 'posts',
          returnModel: true,
        );
        expect(response.modelResponse, isA<PostModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.onPost<PostModel>(
          model: fakerModel,
          extraUri: 'posts',
          returnModel: true,
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Put => ', () {
    test('Return model', () async {
      try {
        final response = await client.onPut<PostModel>(
          model: fakerModel,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
        );
        expect(response.modelResponse, isA<PostModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.onPut<PostModel>(
          model: fakerModel,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Patch => ', () {
    test('Return model', () async {
      try {
        final response = await client.onPatch<PostModel>(
          model: fakerModel,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
        );
        expect(response.modelResponse, isA<PostModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.onPatch<PostModel>(
          model: fakerModel,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Delete => ', () {
    test('Compare response (http client)', () async {
      try {
        final response = await client.onDelete(
          extraUri: 'posts/${fakerModel.id}',
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });
}
