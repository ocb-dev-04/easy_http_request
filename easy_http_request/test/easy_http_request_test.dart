import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';
import 'package:faker/faker.dart';

import 'package:easy_http_request/core/services/http_request.dart';
import 'package:easy_http_request/data/easy_http_request_models.dart';

import 'mock/post_mock.dart';

void main() {
  late EasyHttpRequest client;
  late Faker faker;
  late PostModel fakerModel;

  setUp(() {
    client = EasyHttpRequest();
    client.init(
      config: HttpConfigData(
        baseApi: 'https://jsonplaceholder.typicode.com',
        includeLogger: false, // disable logger just so you don't see all requests in console
      ),
    );
    faker = Faker();
    fakerModel = PostModel(
      id: 1,
      userId: faker.randomGenerator.integer(4000, min: 100),
      title: faker.company.name(),
      body: faker.lorem.sentences(4).join(' '),
    );
  });

  group('On GetOne => ', () {
    test('compare model data', () async {
      try {
        final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
        expect(response.modelResponse, isA<PostModel?>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('compare response (http client)', () async {
      try {
        final response = await client.onGetOne<PostModel>(extraUri: 'posts/1', model: PostModel());
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On GetMany => ', () {
    test('compare model data', () async {
      try {
        final response = await client.onGetMany<PostModel>(extraUri: 'posts', model: PostModel());
        expect(response.modelResponseAsList, isA<List<PostModel?>>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('compare response (http client)', () async {
      try {
        final response = await client.onGetMany<PostModel>(extraUri: 'posts', model: PostModel());
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Post => ', () {
    test('return model', () async {
      try {
        final response = await client.onPost<PostModel>(extraUri: 'posts', model: fakerModel, returnModel: true);
        expect(response.modelResponse, isA<PostModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('compare response (http client)', () async {
      try {
        final response = await client.onPost<PostModel>(extraUri: 'posts', model: fakerModel, returnModel: true);
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Put => ', () {
    test('return model', () async {
      try {
        final response = await client.onPut<PostModel>(extraUri: 'posts/${fakerModel.id}', model: fakerModel, returnModel: true);
        expect(response.modelResponse, isA<PostModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('compare response (http client)', () async {
      try {
        final response = await client.onPut<PostModel>(extraUri: 'posts/${fakerModel.id}', model: fakerModel, returnModel: true);
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Delete => ', () {
    test('OnDelete', () async {
      try {
        final response = await client.onDelete(extraUri: 'posts/${fakerModel.id}');
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });
}
