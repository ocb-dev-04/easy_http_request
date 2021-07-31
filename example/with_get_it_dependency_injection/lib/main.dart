import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:faker/faker.dart';

import 'package:easy_http/data/easy_http_request_models.dart';
import 'package:easy_http/easy_http_request.dart';
import 'package:easy_http/core/parser/http_parser.dart';

void main() {
  // package init
  EasyHttpRequest.init(config: HttpConfigData(baseApi: 'https://jsonplaceholder.typicode.com'));
  DIManager.setup();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const MaterialApp(home: const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final di = HttpServices();
    return Scaffold(
      appBar: AppBar(
        title: Text('EHR With Getx DI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () => di.getOne(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('Get One', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => di.getCollection(),
              color: Theme.of(context).primaryColor,
              child: Text('Get Many', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => di.post(),
              color: Theme.of(context).primaryColor,
              child: Text('POST', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => di.put(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('PUT', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => di.patch(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('PATCH', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => di.delete(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('DELETE', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DIManager {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton<EasyHttpRequestContract>(EasyHttpRequest());
  }
}

class HttpServices {
  static final EasyHttpRequestContract _httpContract = GetIt.instance<EasyHttpRequestContract>();
  static final Faker _faker = Faker();

  final String _extraUri = 'posts';

  PostModel fakerModel = PostModel(
    id: 1,
    userId: _faker.randomGenerator.integer(4000, min: 100),
    title: _faker.company.name(),
    body: _faker.lorem.sentences(4).join(' '),
  );

  Future<void> getOne({required int id}) async {
    try {
      final response = await _httpContract.onGetOne<PostModel>(extraUri: '$_extraUri/$id', model: PostModel());
      final justOne = response.modelResponse!;

      _showInfo(justOne.title!, justOne.body!, 'getOne');
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred', 'getOne');
    }
  }

  Future<void> getCollection() async {
    try {
      final response = await _httpContract.onGetMany<PostModel>(extraUri: _extraUri, model: PostModel());
      final collection = response.modelResponseAsList!;
      _showInfo(collection.last.title!, collection.last.body!, 'getCollection');
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred', 'getCollection');
    }
  }

  Future<void> post() async {
    try {
      // If your service return model is created and you need to update the UI with this data, you can do this
      final response = await _httpContract.onPost<PostModel>(extraUri: _extraUri, model: fakerModel, returnModel: true);

      // Just create
      // final justCreate = await _httpContract.onPost<PostModel>(extraUri: 'posts', model: fakerModel /* returnModel is false by default */);

      // You can also send query Params instead of sending ids and others directly in the path
      // final withQueryParams = await _httpContract.onPost<PostModel>(extraUri: 'posts', queryParams: {"id": fakerModel.id}, model: fakerModel /* returnModel is false by default */);

      // if service return a 201 Created status code (is just example)
      if (response.completeResponse!.statusCode == 201) {
        _showInfo('CREATED', 'Info created', 'post');
      } else {
        _showInfo('Ups!!', 'Some error ocurred', 'post');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred', 'post');
    }
  }

  Future<void> put({required int id}) async {
    try {
      // If your service return model is up to date and you need to update the UI with this data, you can do this
      final response = await _httpContract.onPut<PostModel>(extraUri: '$_extraUri/${fakerModel.id}', model: fakerModel, returnModel: true);

      // Just update
      // final justUpdate = await _httpContract.onPut<PostModel>(extraUri: 'posts/${fakerModel.id}', model: fakerModel /* returnModel is false by default */);

      // You can also send query Params instead of sending ids and others directly in the path
      // final withQueryParams = await _httpContract.onPut<PostModel>(extraUri: 'posts', queryParams: {"id": fakerModel.id}, model: fakerModel /* returnModel is false by default */);

      // if service return a 200 OK status code (is just example)
      if (response.completeResponse!.statusCode == 200) {
        _showInfo('UPDATED', 'Info updated', 'put');
      } else {
        _showInfo('Ups!!', 'Some error ocurred', 'put');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred', 'put');
    }
  }

  Future<void> patch({required int id}) async {
    try {
      // If your service return model is up to date and you need to update the UI with this data, you can do this
      final response = await _httpContract.onPatch<PostModel>(extraUri: '$_extraUri/${fakerModel.id}', model: fakerModel, returnModel: true);

      // Just update
      // final justUpdate = await _httpContract.onPatch<PostModel>(extraUri: 'posts/${fakerModel.id}', model: fakerModel /* returnModel is false by default */);

      // You can also send query Params instead of sending ids and others directly in the path
      // final withQueryParams = await _httpContract.onPatch<PostModel>(extraUri: 'posts', queryParams: {"id": fakerModel.id}, model: fakerModel /* returnModel is false by default */);

      // if service return a 200 OK status code (is just example)
      if (response.completeResponse!.statusCode == 200) {
        _showInfo('UPDATED', 'Info updated', 'patch');
      } else {
        _showInfo('Ups!!', 'Some error ocurred', 'patch');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred', 'patch');
    }
  }

  Future<void> delete({required int id}) async {
    try {
      final response = await _httpContract.onDelete(extraUri: '$_extraUri/$id');

      // if service return a 200 OK status code (is just example)
      if (response.completeResponse!.statusCode == 200) {
        _showInfo('DELETED', 'Info deleted', 'delete');
      } else {
        _showInfo('Ups!!', 'Some error ocurred', 'delete');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred', 'delete');
    }
  }

  void _showInfo(String title, String message, String http) {
    debugPrint('***************************************************************');
    debugPrint(http.toUpperCase());
    debugPrint('Title => $title');
    debugPrint('Body => $message');
    debugPrint('***************************************************************');
  }
}

class PostModel implements HttpDataParser<PostModel> {
  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  @override
  PostModel fromJson(Map<String, dynamic> json) => PostModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
