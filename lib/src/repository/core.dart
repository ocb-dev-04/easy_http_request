import 'package:dio/dio.dart';
import 'package:easy_http_request/src/config/http_client_config.dart';
import 'package:easy_http_request/src/models/easy_http_request_models.dart';
import 'package:easy_http_request/src/parser/http_parser.dart';

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
  @override
  Future<EasyHttpRequestResponse<T>> requestWithSinglePATH<T extends HttpDataParser<T>>({
    required T model,
    required EasyHttpType requestType,
    String extraUri = '',
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  }) async {
    final client = EasyHttpClient.singleClient;

    return await _makeRequest<T>(
      client: client,
      model: model,
      requestType: requestType,
      extraUri: extraUri,
      queryParams: queryParams,
    );
  }

  @override
  Future<EasyHttpRequestResponse<T>> requestWithManyPATH<T extends HttpDataParser<T>>({
    required T model,
    required String identifier,
    required EasyHttpType requestType,
    String extraUri = '',
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  }) async {
    if (identifier.isEmpty) throw Exception('Need a identifier to access to Http Client instance');

    final client = EasyHttpClient.getFromMany(identifier);
    return await _makeRequest<T>(
      client: client,
      model: model,
      requestType: requestType,
      extraUri: extraUri,
      queryParams: queryParams,
    );
  }

  Future<EasyHttpRequestResponse<T>> _makeRequest<T extends HttpDataParser<T>>({
    required SingleClientInstance client,
    required T model,
    required EasyHttpType requestType,
    String extraUri = '',
    Map<String, dynamic> queryParams = const {},
    bool returnModel = true,
  }) async {
    late Response response;
    late EasyHttpRequestResponse<T> responseModel;
    try {
      switch (requestType) {
        case EasyHttpType.getSingle:
          response = await client.dio.get(extraUri, queryParameters: queryParams);
          break;
        case EasyHttpType.getCollection:
          response = await client.dio.get(extraUri, queryParameters: queryParams);
          break;
        case EasyHttpType.post:
          response = await client.dio.post(extraUri, queryParameters: queryParams, data: model.toJson());
          break;
        case EasyHttpType.put:
          response = await client.dio.put(extraUri, queryParameters: queryParams, data: model.toJson());
          break;
        case EasyHttpType.patch:
          response = await client.dio.patch(extraUri, queryParameters: queryParams, data: model.toJson());
          break;
        case EasyHttpType.delete:
          response = await client.dio.delete(extraUri, queryParameters: queryParams);
          returnModel = false;
          break;
        default:
      }

      responseModel = EasyHttpRequestResponse(completeResponse: response);

      if (response.statusCode! > client.config.validStatus) return responseModel;

      if (returnModel) {
        requestType == EasyHttpType.getCollection
            ? responseModel.modelResponseAsList = (response.data! as List).map((e) => model.fromJson(e as Map<String, dynamic>)).toList()
            : responseModel.modelResponse = model.fromJson(response.data! as Map<String, dynamic>);
      }

      return responseModel;
    } catch (e) {
      rethrow;
    }
  }
}

/// Contract with all methods to implement in EasyHttpRequest
abstract class EasyHttpRequestContract {
  /// Method to make request by EasyHttpType on SINGLE API PATH.
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
  Future<EasyHttpRequestResponse<T>> requestWithSinglePATH<T extends HttpDataParser<T>>({
    required T model,
    required EasyHttpType requestType,
    String extraUri = '',
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  });

  /// Method to make request by EasyHttpType on MANY API PATH.
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
  Future<EasyHttpRequestResponse<T>> requestWithManyPATH<T extends HttpDataParser<T>>({
    required T model,
    required String identifier,
    required EasyHttpType requestType,
    String extraUri = '',
    Map<String, dynamic> queryParams = const {},
    bool returnModel = false,
  });
}

/// Set request type
enum EasyHttpType {
  /// Set request to get SINGLE model on response
  getSingle,

  /// Set request to get COLLECTION model on response
  getCollection,

  /// Set request to POST
  post,

  /// Set request to PUT
  put,

  /// Set request to PATCH
  patch,

  /// Set request to DELETE
  delete,
}
