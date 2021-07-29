import 'package:dio/dio.dart';

import 'package:easy_http_request/core/contracts/http_contract.dart';
import 'package:easy_http_request/core/parser/http_parser.dart';
import 'package:easy_http_request/data/easy_http_request_models.dart';
import 'package:easy_http_request/dio_config.dart';

class EasyHttpRequest implements HttpContract {
  late Dio _dio;
  late HttpConfigData _config;

  void init({required HttpConfigData config}) {
    _dio = HttpClient.getClient(config: config);
    _config = config;
  }

  @override
  Future<EasyHttpRequestResponse<T>> onGetOne<T extends HttpDataParser<T>>({
    required String extraUri,
    Map<String, dynamic> queryParams = const {},
    required T model,
  }) async {
    try {
      final Response response = await _dio.get(extraUri, queryParameters: queryParams);
      EasyHttpRequestResponse<T> responseModel = EasyHttpRequestResponse<T>(completeResponse: response);
      if (response.statusCode! > _config.validStatus) return responseModel;

      return responseModel..modelResponse = model.fromJson(response.data! as Map<String, dynamic>);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onGetMany<T extends HttpDataParser<T>>({
    required String extraUri,
    Map<String, dynamic> queryParams = const {},
    required T model,
  }) async {
    try {
      final Response response = await _dio.get(extraUri, queryParameters: queryParams);
      EasyHttpRequestResponse<T> responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      if (response.statusCode! > _config.validStatus) return responseModel;

      return responseModel..modelResponseAsList = (response.data! as List<dynamic>).map((e) => model.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPost<T extends HttpDataParser<T>>({
    required String extraUri,
    required T model,
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  }) async {
    try {
      final Response response = await _dio.post(extraUri, queryParameters: queryParams, data: model.toJson());
      EasyHttpRequestResponse<T> responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      if (response.statusCode! > _config.validStatus) return responseModel;

      return returnModel ? responseModel : responseModel
        ..modelResponse = model.fromJson(response.data! as Map<String, dynamic>);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPut<T extends HttpDataParser<T>>({
    required String extraUri,
    required T model,
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  }) async {
    try {
      final Response response = await _dio.put(extraUri, queryParameters: queryParams, data: model.toJson());
      EasyHttpRequestResponse<T> responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      final data = response.data!;
      if (response.statusCode! > _config.validStatus) return responseModel;

      return returnModel ? responseModel : responseModel
        ..modelResponse = model.fromJson(data);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<EasyHttpRequestResponse> onDelete({
    required String extraUri,
    Map<String, dynamic> queryParams = const {},
  }) async {
    try {
      final Response response = await _dio.delete(extraUri, queryParameters: queryParams);

      return EasyHttpRequestResponse(completeResponse: response);
    } catch (e) {
      throw e;
    }
  }
}
