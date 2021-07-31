library easy_http;

import 'dart:core';

import 'package:dio/dio.dart';

import 'package:easy_http_request/core/parser/http_parser.dart';
import 'package:easy_http_request/data/easy_http_request_models.dart';
import 'package:easy_http_request/core/config/dio_config.dart';

// *****************************************************************************

/* 
	* I defined the contract in this same file so that if the developer needs to 
	* use it they don't have to import something extra. I mean, if I use 
	* EasyHttpRequest I also have access to EasyHttpRequestContract.
*/

// *****************************************************************************

/// Main class of the package. Contains all the methods you can use.
///
/// Implement EasyHttpRequestContract.
class EasyHttpRequest implements EasyHttpRequestContract {
  static late Dio _dio;
  static late EasyHttpConfig _config;
  static late HttpConfigOptions _options;

  /// Method to initialize the package with just a endpoint (base url - baseApi)
  static void init({
    required EasyHttpConfig config,
    HttpConfigOptions options = HttpConfigOptions.oneEndpoint,
  }) {
    _dio = HttpClient.getClient(config: config);
    _config = config;
    _options = options;
  }

  @override
  Future<EasyHttpRequestResponse<T>> onGetOne<T extends HttpDataParser<T>>({
    required T model,
    String extraUri = '',
    Map<String, dynamic> queryParams = const {},
  }) async {
    try {
      switch (_options) {
        case HttpConfigOptions.oneEndpoint:
          break;
        case HttpConfigOptions.manyEndpointSameConfig:
          break;
        case HttpConfigOptions.manyEndpointsDiferentsConfig:
          break;
        default:
      }
      final response = await _dio.get(extraUri, queryParameters: queryParams);
      final responseModel = EasyHttpRequestResponse<T>(completeResponse: response);
      if (response.statusCode! > _config.validStatus) return responseModel;

      return responseModel..modelResponse = model.fromJson(response.data! as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onGetMany<T extends HttpDataParser<T>>(
      {required T model, String extraUri = '', Map<String, dynamic> queryParams = const {}}) async {
    try {
      final response = await _dio.get(extraUri, queryParameters: queryParams);
      final responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      if (response.statusCode! > _config.validStatus) return responseModel;

      return responseModel..modelResponseAsList = (response.data! as List).map((e) => model.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPost<T extends HttpDataParser<T>>(
      {required T model, String extraUri = '', Map<String, dynamic> queryParams = const {}, bool returnModel = false}) async {
    try {
      final response = await _dio.post(extraUri, queryParameters: queryParams, data: model.toJson());
      final responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      if (response.statusCode! > _config.validStatus) return responseModel;

      return returnModel ? responseModel : responseModel
        ..modelResponse = model.fromJson(response.data! as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPut<T extends HttpDataParser<T>>(
      {required T model, String extraUri = '', Map<String, dynamic> queryParams = const {}, bool returnModel = false}) async {
    try {
      final response = await _dio.put(extraUri, queryParameters: queryParams, data: model.toJson());
      final responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      final data = response.data;
      if (response.statusCode! > _config.validStatus) return responseModel;

      return returnModel ? responseModel : responseModel
        ..modelResponse = model.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EasyHttpRequestResponse<T>> onPatch<T extends HttpDataParser<T>>(
      {required T model, String extraUri = '', Map<String, dynamic> queryParams = const {}, bool returnModel = false}) async {
    try {
      final response = await _dio.patch(extraUri, queryParameters: queryParams, data: model.toJson());
      final responseModel = EasyHttpRequestResponse<T>(completeResponse: response);

      final data = response.data;
      if (response.statusCode! > _config.validStatus) return responseModel;

      return returnModel ? responseModel : responseModel
        ..modelResponse = model.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EasyHttpRequestResponse<dynamic>> onDelete({required String extraUri, Map<String, dynamic> queryParams = const {}}) async {
    try {
      final response = await _dio.delete(extraUri, queryParameters: queryParams);
      return EasyHttpRequestResponse(completeResponse: response);
    } catch (e) {
      rethrow;
    }
  }
}

/// Contract with all methods to implement in EasyHttpRequest
abstract class EasyHttpRequestContract {
  /// Method to consult only one model.
  ///
  /// Parameters:
  ///
  /// model (required): The model that will be handled in the query.
  /// You must implement HttpDataParser.
  ///
  /// extraUri (optional): If apart from the base api that you initialized
  /// the package with, you need to add more information.
  ///
  /// Example:
  ///
  /// Your api base is https://www.domain.com/api and your endpoint to consult is https://www.domain.com/api/users in this parameter you add the part of [users] to complete the endpoint
  ///
  /// queryParams (optional): You can send the query parameters directly in
  /// the path, but it is more recommended to use key: value for this.
  ///
  /// Example:
  ///
  /// https://www.domain.com/api/users/id=3 has id = 3 as a parameter. With this property you can do this: {"id": 3}
  ///
  /// And it will be exactly the same
  Future<EasyHttpRequestResponse<T>> onGetOne<T extends HttpDataParser<T>>({required T model, String extraUri, Map<String, dynamic> queryParams = const {}});

  /// Method to consult a collection of a model.
  ///
  /// Parameters:
  ///
  /// model (required): The model that will be handled in the query. You must
  /// implement HttpDataParser.
  ///
  /// extraUri (optional): If apart from the base api that you initialized the
  /// package with, you need to add more information.
  ///
  /// Example:
  ///
  /// Your api base is https://www.domain.com/api and your endpoint to consult is https://www.domain.com/api/users in this parameter you add the part of [users] to complete the endpoint
  ///
  /// queryParams (optional): You can send the query parameters directly in the
  /// path, but it is more recommended to use key: value for this.
  ///
  /// Example:
  ///
  /// https://www.domain.com/api/users/id=3 has id = 3 as a parameter. With this property you can do this: {"id": 3}
  ///
  /// And it will be exactly the same
  Future<EasyHttpRequestResponse<T>> onGetMany<T extends HttpDataParser<T>>({required T model, String extraUri, Map<String, dynamic> queryParams = const {}});

  /// Method for submitting information to be created. (POST).
  ///
  /// Parameters:
  ///
  /// model (required): The model that will be handled in the query. You must
  /// implement HttpDataParser.
  ///
  /// extraUri (optional): If apart from the base api that you initialized the
  /// package with, you need to add more information.
  ///
  /// Example:
  ///
  /// Your api base is https://www.domain.com/api and your endpoint to consult is https://www.domain.com/api/users in this parameter you add the part of [users] to complete the endpoint
  ///
  /// queryParams (optional): You can send the query parameters directly in the
  /// path, but it is more recommended to use key: value for this.
  ///
  /// Example:
  ///
  /// https://www.domain.com/api/users/id=3 has id = 3 as a parameter. With this property you can do this: {"id": 3}
  ///
  /// And it will be exactly the same
  ///
  /// returnModel(optional): You can set it to true if your service returns a
  /// json of your model that has just been created and you need that
  /// information to save it locally or to update the UI
  Future<EasyHttpRequestResponse<T>> onPost<T extends HttpDataParser<T>>(
      {required T model, String extraUri, Map<String, dynamic> queryParams = const {}, bool returnModel = false});

  /// Method for submitting information to be updated. (PUT).
  ///
  /// Parameters:
  ///
  /// model (required): The model that will be handled in the query. You
  /// must implement HttpDataParser.
  ///
  /// extraUri (optional): If apart from the base api that you initialized
  /// the package with, you need to add more information.
  ///
  /// Example:
  ///
  /// Your api base is https://www.domain.com/api and your endpoint to consult is https://www.domain.com/api/users in this parameter you add the part of [users] to complete the endpoint
  ///
  /// queryParams (optional): You can send the query parameters directly in
  /// the path, but it is more recommended to use key: value for this.
  ///
  /// Example:
  ///
  /// https://www.domain.com/api/users/id=3 has id = 3 as a parameter. With this property you can do this: {"id": 3}
  ///
  /// And it will be exactly the same
  ///
  /// returnModel(optional): You can set it to true if your service returns a
  /// json of your model that has just been updated and you need that
  /// information to save it locally or to update the UI
  Future<EasyHttpRequestResponse<T>> onPut<T extends HttpDataParser<T>>(
      {required T model, String extraUri, Map<String, dynamic> queryParams = const {}, bool returnModel = false});

  /// Method for submitting information to be updated. (PATCH).
  ///
  /// Parameters:
  ///
  /// model (required): The model that will be handled in the query. You must
  /// implement HttpDataParser.
  ///
  /// extraUri (optional): If apart from the base api that you initialized the
  /// package with, you need to add more information.
  ///
  /// Example:
  ///
  /// Your api base is https://www.domain.com/api and your endpoint to consult is https://www.domain.com/api/users in this parameter you add the part of [users] to complete the endpoint
  ///
  /// queryParams (optional): You can send the query parameters directly in the
  /// path, but it is more recommended to use key: value for this.
  ///
  /// Example:
  ///
  /// https://www.domain.com/api/users/id=3 has id = 3 as a parameter. With this property you can do this: {"id": 3}
  ///
  /// And it will be exactly the same
  ///
  /// returnModel(optional): You can set it to true if your service returns a
  /// json of your model that has just been updated and you need that
  /// information to save it locally or to update the UI
  Future<EasyHttpRequestResponse<T>> onPatch<T extends HttpDataParser<T>>(
      {required T model, String extraUri, Map<String, dynamic> queryParams = const {}, bool returnModel = false});

  /// Method for submitting information to be removed. (DELETE).
  ///
  /// Parameters:
  ///
  /// extraUri (optional): If apart from the base api that you initialized the
  /// package with, you need to add more information.
  ///
  /// Example:
  ///
  /// Your api base is https://www.domain.com/api and your endpoint to consult is https://www.domain.com/api/users in this parameter you add the part of [users] to complete the endpoint
  ///
  /// queryParams (optional): You can send the query parameters directly in the
  /// path, but it is more recommended to use key: value for this.
  ///
  /// Example:
  ///
  /// https://www.domain.com/api/users/id=3 has id = 3 as a parameter. With this property you can do this: {"id": 3}
  ///
  /// And it will be exactly the same
  Future<EasyHttpRequestResponse<dynamic>> onDelete({required String extraUri, Map<String, dynamic> queryParams = const {}});
}

/// Set way to configure package
enum HttpConfigOptions {
  /// If you only use an endpoint (baseUrl)
  oneEndpoint,

  /// If you use multiple endpoints (baseUrl) with different configurations
  manyEndpointsDiferentsConfig,

  /// If you will use multiple endpoints but, with the same configuration
  manyEndpointSameConfig,
}
