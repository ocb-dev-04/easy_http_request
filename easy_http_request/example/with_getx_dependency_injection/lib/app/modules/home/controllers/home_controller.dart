import 'package:easy_http_request/easy_http_request.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';

import '../../../data/models/post_model.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;

  late EasyHttpRequestContract _httpContract;
  late Faker _faker;

  PostModel justOne = PostModel();
  List<PostModel> collection = List<PostModel>.empty(growable: true);
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
      startLoading();
      final response = await _httpContract.onGetOne<PostModel>(extraUri: 'posts/$id', model: PostModel());
      justOne = response.modelResponse!;
    } catch (e) {
      Get.snackbar('Ups!!', 'Some error ocurred');
    } finally {
      stopLoading();
    }
  }

  Future<void> getCollection() async {
    try {
      startLoading();
      final response = await _httpContract.onGetMany<PostModel>(extraUri: 'posts', model: PostModel());
      collection = response.modelResponseAsList!;
    } catch (e) {
      Get.snackbar('Ups!!', 'Some error ocurred');
    } finally {
      stopLoading();
    }
  }

  Future<void> post() async {
    try {
      startLoading();
      // If your service return model is created and you need to update the UI with this data, you can do this
      final response = await _httpContract.onPost<PostModel>(extraUri: 'posts', model: fakerModel, returnModel: true);

      // Just create
      // final justCreate = await _httpContract.onPost<PostModel>(extraUri: 'posts', model: fakerModel /* returnModel is false by default */);

      // You can also send query Params instead of sending ids and others directly in the path
      // final withQueryParams = await _httpContract.onPost<PostModel>(extraUri: 'posts', queryParams: {"id": fakerModel.id}, model: fakerModel /* returnModel is false by default */);

      // if service return a 201 Created status code (is just example)
      if (response.completeResponse!.statusCode == 201) {
        Get.snackbar('Ready', 'Info updated');
      } else {
        Get.snackbar('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      Get.snackbar('Ups!!', 'Some error ocurred');
    } finally {
      stopLoading();
    }
  }

  Future<void> put() async {
    try {
      startLoading();
      // If your service return model is up to date and you need to update the UI with this data, you can do this
      final response = await _httpContract.onPut<PostModel>(extraUri: 'posts/${fakerModel.id}', model: fakerModel, returnModel: true);

      // Just update
      // final justUpdate = await _httpContract.onPut<PostModel>(extraUri: 'posts/${fakerModel.id}', model: fakerModel /* returnModel is false by default */);

      // You can also send query Params instead of sending ids and others directly in the path
      // final withQueryParams = await _httpContract.onPut<PostModel>(extraUri: 'posts', queryParams: {"id": fakerModel.id}, model: fakerModel /* returnModel is false by default */);

      // if service return a 200 OK status code (is just example)
      if (response.completeResponse!.statusCode == 200) {
        Get.snackbar('Ready', 'Info updated');
      } else {
        Get.snackbar('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      Get.snackbar('Ups!!', 'Some error ocurred');
    } finally {
      stopLoading();
    }
  }

  Future<void> delete({required int id}) async {
    try {
      startLoading();
      final response = await _httpContract.onDelete(extraUri: 'posts/$id');

      // if service return a 200 OK status code (is just example)
      if (response.completeResponse!.statusCode == 200) {
        Get.snackbar('Ready', 'Info deleted');
      } else {
        Get.snackbar('Ups!!', 'Some error ocurred');
      }
    } catch (e) {
      Get.snackbar('Ups!!', 'Some error ocurred');
    } finally {
      stopLoading();
    }
  }

  void startLoading() => loading.value = true;

  void stopLoading() => loading.value = false;
}
