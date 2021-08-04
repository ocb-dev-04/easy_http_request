import 'package:easy_http_request/src/models/easy_http_request_models.dart';
import 'package:easy_http_request/easy_http_request.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';
import 'package:faker/faker.dart';

import 'mock/models/post_mock.dart';
import 'mock/models/products_mock.dart';

var count = 0;

void main() {
  late EasyHttpRequest client;
  late Faker faker;
  late PostModel fakerModel;
  late ProductsModel prodFakerModel;
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
          includeLogger: false,
        ),
        EasyHttpConfig(
          apiPath: 'https://fakestoreapi.com',
          identifier: secondIdentifier,
          // disable the logger just so you don't see all the requests in the console
          includeLogger: false,
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
    prodFakerModel = ProductsModel(
      id: 1,
      email: faker.internet.safeEmail(),
      password: faker.internet.password(),
      phone: faker.phoneNumber.us(),
      username: faker.person.name(),
    );
    count++;
  });

  group('Change on board', () {
    test('Change Headers', () async {
      try {
        // add headers
        EasyHeadersManager.addHeadersManyClient(identifier: firstIdentifier, newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
        EasyHeadersManager.addHeadersManyClient(identifier: secondIdentifier, newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});

        // update header
        EasyHeadersManager.updateHeadersManyClient(identifier: firstIdentifier, key: 'jwt', value: 'poiuytrewq');
        EasyHeadersManager.updateHeadersManyClient(identifier: secondIdentifier, key: 'api_key', value: '174091u1j2e091j2');

        // remove header
        EasyHeadersManager.removeHeadersManyClient(identifier: firstIdentifier, key: 'api_key');
        EasyHeadersManager.removeHeadersManyClient(identifier: secondIdentifier, key: 'jwt');
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Get Single => ', () {
    test('Compare model data', () async {
      try {
        final first = await client.requestWithManyPATH<PostModel>(
          model: PostModel(),
          identifier: firstIdentifier,
          requestType: EasyHttpType.getSingle,
          extraUri: 'posts/1',
        );
        final second = await client.requestWithManyPATH<ProductsModel>(
          model: ProductsModel(),
          identifier: secondIdentifier,
          requestType: EasyHttpType.getSingle,
          extraUri: 'users/1',
        );
        expect(first.modelResponse, isA<PostModel?>());
        expect(second.modelResponse, isA<ProductsModel?>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Get Collection => ', () {
    test('Compare model data', () async {
      try {
        final first = await client.requestWithManyPATH<PostModel>(
          model: PostModel(),
          requestType: EasyHttpType.getCollection,
          extraUri: 'posts',
          identifier: firstIdentifier,
        );
        final second = await client.requestWithManyPATH<ProductsModel>(
          model: ProductsModel(),
          requestType: EasyHttpType.getCollection,
          extraUri: 'users',
          identifier: secondIdentifier,
        );
        expect(first.modelResponseAsList, isA<List<PostModel?>>());
        expect(second.modelResponseAsList, isA<List<ProductsModel?>>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Post => ', () {
    test('Return model', () async {
      try {
        final first = await client.requestWithManyPATH<PostModel>(
          model: fakerModel,
          requestType: EasyHttpType.post,
          extraUri: 'posts',
          returnModel: true,
          identifier: firstIdentifier,
        );
        final second = await client.requestWithManyPATH<ProductsModel>(
          model: prodFakerModel,
          requestType: EasyHttpType.post,
          extraUri: 'users',
          returnModel: true,
          identifier: firstIdentifier,
        );
        expect(first.modelResponse, isA<PostModel>());
        expect(second.modelResponse, isA<ProductsModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.requestWithManyPATH<PostModel>(
          model: fakerModel,
          requestType: EasyHttpType.post,
          extraUri: 'posts',
          returnModel: true,
          identifier: firstIdentifier,
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
        final first = await client.requestWithManyPATH<PostModel>(
          model: fakerModel,
          requestType: EasyHttpType.put,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
          identifier: firstIdentifier,
        );
        final second = await client.requestWithManyPATH<ProductsModel>(
          model: prodFakerModel,
          requestType: EasyHttpType.put,
          extraUri: 'posts/${prodFakerModel.id}',
          returnModel: true,
          identifier: firstIdentifier,
        );
        expect(first.modelResponse, isA<PostModel>());
        expect(second.modelResponse, isA<ProductsModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });

  group('On Patch => ', () {
    test('Return model', () async {
      try {
        final first = await client.requestWithManyPATH<PostModel>(
          model: fakerModel,
          requestType: EasyHttpType.patch,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
          identifier: firstIdentifier,
        );
        final second = await client.requestWithManyPATH<ProductsModel>(
          model: prodFakerModel,
          requestType: EasyHttpType.patch,
          extraUri: 'users/${prodFakerModel.id}',
          returnModel: true,
          identifier: firstIdentifier,
        );
        expect(first.modelResponse, isA<PostModel>());
        expect(second.modelResponse, isA<ProductsModel>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });

    test('Compare response (http client)', () async {
      try {
        final response = await client.requestWithManyPATH<PostModel>(
          model: fakerModel,
          requestType: EasyHttpType.patch,
          extraUri: 'posts/${fakerModel.id}',
          returnModel: true,
          identifier: firstIdentifier,
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
        final first = await client.requestWithManyPATH<PostModel>(
          model: PostModel(),
          requestType: EasyHttpType.delete,
          extraUri: 'posts/${fakerModel.id}',
          identifier: firstIdentifier,
        );
        final second = await client.requestWithManyPATH<ProductsModel>(
          model: ProductsModel(),
          requestType: EasyHttpType.delete,
          extraUri: 'users/${prodFakerModel.id}',
          identifier: firstIdentifier,
        );
        expect(first.completeResponse, isA<Response>());
        expect(second.completeResponse, isA<Response>());
      } catch (e) {
        expect(e, isA<DioError>());
      }
    });
  });
}
