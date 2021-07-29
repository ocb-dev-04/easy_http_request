import 'dart:core';

import 'package:easy_http_request/core/parser/http_parser.dart';
import 'package:easy_http_request/data/easy_http_request_models.dart';

abstract class HttpContract {
  Future<EasyHttpRequestResponse<T>> onGetOne<T extends HttpDataParser<T>>(
      {required String extraUri, required T model, Map<String, dynamic> queryParams = const {}});
  Future<EasyHttpRequestResponse<T>> onGetMany<T extends HttpDataParser<T>>(
      {required String extraUri, required T model, Map<String, dynamic> queryParams = const {}});
  Future<EasyHttpRequestResponse<T>> onPost<T extends HttpDataParser<T>>(
      {required String extraUri, required T model, Map<String, dynamic> queryParams = const {}, bool returnModel = false});
  Future<EasyHttpRequestResponse<T>> onPut<T extends HttpDataParser<T>>(
      {required String extraUri, required T model, Map<String, dynamic> queryParams = const {}, bool returnModel = false});
  Future<EasyHttpRequestResponse> onDelete({required String extraUri, Map<String, dynamic> queryParams = const {}});
}
