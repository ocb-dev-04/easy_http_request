import 'package:easy_http_request/data/easy_http_request_models.dart';
import 'package:easy_http_request/easy_http_request.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';
import 'package:faker/faker.dart';

import 'mock/models/post_mock.dart';

var count = 0;

void main() {
  late EasyHttpRequest client;
  late Faker faker;
  late PostModel fakerModel;
  const firstIdentifier = 'FirstApiPath';
  const secondIdentifier = 'SecondApiPath';

  setUp(() {
    /*
			* The setup method is cyclical, when the method is repeated 
			* it executes the initWithManyApi again, and it already has 
			* the identifiers saved, therefore it throws an exception. 
			* So it is valid that it is only initialized in the first 
			* cycle, if it is greater than 0 (if it is a second cycle), 
			* it only returns 
		*/
    if (count > 0) return;

    EasyHttpSettings.initWithManyApi(
      config: [
        EasyHttpConfig(
          apiPath: 'https://jsonplaceholder.typicode.com',
          identifier: firstIdentifier,
          // disable the logger just so you don't see all the requests in the console
          // includeLogger: false,
        ),
        EasyHttpConfig(
          apiPath: 'https://jsonplaceholder.typicode.com',
          identifier: secondIdentifier,
          // disable the logger just so you don't see all the requests in the console
          // includeLogger: false,
        ),
      ],
    );
    client = EasyHttpRequest();
    faker = Faker();
    fakerModel = PostModel(
      id: 1,
      userId: faker.randomGenerator.integer(4000, min: 100),
      title: faker.company.name(),
      body: faker.lorem.sentences(4).join(' '),
    );
    count++;
  });

  group('Change on board', () {
    test('Change Headers', () async {
      try {
        // add headers
        EasyHttpSettings.addHeadersManyClient(identifier: firstIdentifier, newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
        EasyHttpSettings.addHeadersManyClient(identifier: secondIdentifier, newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});

        // update header
        EasyHttpSettings.updateHeadersManyClient(identifier: firstIdentifier, key: 'jwt', value: 'poiuytrewq');
        EasyHttpSettings.updateHeadersManyClient(identifier: secondIdentifier, key: 'api_key', value: '174091u1j2e091j2');

        // remove header
        EasyHttpSettings.removeHeadersManyClient(identifier: firstIdentifier, key: 'api_key');
        EasyHttpSettings.removeHeadersManyClient(identifier: secondIdentifier, key: 'jwt');
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Get Single => ', () {
    test('Compare model data', () async {
      try {
        final response = await client.onGetSingle<PostModel>(
          model: PostModel(),
          extraUri: 'posts/1',
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
        );
        expect(response.modelResponse, isA<PostModel?>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.onGetSingle<PostModel>(
          model: PostModel(),
          extraUri: 'posts/1',
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
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
          identifier: firstIdentifier,
          apiOption: HttpConfigOptions.manyApiPaths,
        );
        expect(response.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });
}
