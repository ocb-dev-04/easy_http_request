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
    final Response response = await _dio.get(extraUri, queryParameters: queryParams);

    final data = response.data! as Map<String, dynamic>;
    if (response.statusCode! > _config.validStatus) return EasyHttpRequestResponse<T>(completeResponse: response);

    return EasyHttpRequestResponse(completeResponse: response)..modelResponse = model.fromJson(data);
  }

  @override
  Future<EasyHttpRequestResponse<T>> onGetMany<T extends HttpDataParser<T>>({
    required String extraUri,
    Map<String, dynamic> queryParams = const {},
    required T model,
  }) async {
    final Response response = await _dio.get(extraUri, queryParameters: queryParams);

    final data = response.data! as List<Map<String, dynamic>>;
    if (response.statusCode! > _config.validStatus) return EasyHttpRequestResponse<T>(completeResponse: response);

    return EasyHttpRequestResponse(completeResponse: response)..modelResponseAsList = data.map((e) => model.fromJson(e)).toList();
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPost<T extends HttpDataParser<T>>({
    required String extraUri,
    required T model,
    bool returnModel = false,
  }) async {
    final Response<T> response = await _dio.post<T>(extraUri, data: model.toJson());

    final data = response.data!;
    if (response.statusCode! > _config.validStatus) return EasyHttpRequestResponse<T>(completeResponse: response);

    return returnModel ? EasyHttpRequestResponse(completeResponse: response) : EasyHttpRequestResponse(completeResponse: response)
      ..modelResponse = data;
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPut<T extends HttpDataParser<T>>({
    required String extraUri,
    required T model,
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  }) async {
    final Response response = await _dio.put(extraUri, data: model.toJson());

    final data = response.data!;
    if (response.statusCode! > _config.validStatus) return EasyHttpRequestResponse<T>(completeResponse: response);

    return returnModel ? EasyHttpRequestResponse(completeResponse: response) : EasyHttpRequestResponse(completeResponse: response)
      ..modelResponse = model.fromJson(data);
  }

  @override
  Future<EasyHttpRequestResponse> onDelete({
    required String extraUri,
    Map<String, dynamic> queryParams = const {},
  }) async {
    final Response response = await _dio.delete(extraUri, queryParameters: queryParams);

    return EasyHttpRequestResponse(completeResponse: response);
  }
}
