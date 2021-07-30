import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_http_request/easy_http_request.dart';
import 'package:faker/faker.dart';

import '../../../data/models/post_model.dart';

class HomeController extends GetxController {
  late EasyHttpRequestContract _httpContract;
  late Faker _faker;

  final String _extraUri = 'posts';

  PostModel fakerModel = PostModel();

  HomeController({required EasyHttpRequestContract httpContract}) {
    _httpContract = httpContract;
    _faker = Faker();

    // create a faker model
    fakerModel = PostModel(
      id: 1,
      userId: _faker.randomGenerator.integer(4000, min: 100),
      title: _faker.company.name(),
      body: _faker.lorem.sentences(4).join(' '),
    );
  }

  Future<void> getOne({required int id}) async {
    try {
      final response = await _httpContract.onGetOne<PostModel>(extraUri: '$_extraUri/$id', model: PostModel());
      final justOne = response.modelResponse!;

      _showInfo(justOne.title!, justOne.body!);
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred');
    }
  }

  Future<void> getCollection() async {
    try {
      final response = await _httpContract.onGetMany<PostModel>(extraUri: _extraUri, model: PostModel());
      final collection = response.modelResponseAsList!;
      _showInfo(collection.last.title!, collection.last.body!);
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred');
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
        _showInfo('CREATED', 'Info created');
      } else {
        _showInfo('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred');
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
        _showInfo('UPDATED', 'Info updated');
      } else {
        _showInfo('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred');
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
        _showInfo('UPDATED', 'Info updated');
      } else {
        _showInfo('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred');
    }
  }

  Future<void> delete({required int id}) async {
    try {
      final response = await _httpContract.onDelete(extraUri: '$_extraUri/$id');

      // if service return a 200 OK status code (is just example)
      if (response.completeResponse!.statusCode == 200) {
        _showInfo('DELETED', 'Info deleted');
      } else {
        _showInfo('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      _showInfo('Ups!!', 'Some error ocurred');
    }
  }

  // This snackbar is for example only. Please do not use any kind of UI interaction outside of your Widget
  void _showInfo(String title, String message) => Get.snackbar(
        title,
        message,
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        borderWidth: 2,
        borderRadius: 10,
      );
}
