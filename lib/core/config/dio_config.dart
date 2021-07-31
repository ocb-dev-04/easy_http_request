import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';

import 'package:easy_http_request/data/easy_http_request_models.dart';

/// Class to configure the http client (Dio)
class HttpClient {
  /// Allows access to the previously configured http client
  static Dio getClient({required EasyHttpConfig config}) {
    final dio = Dio();
    dio.options.baseUrl = '${config.baseApi}/';
    dio.options.connectTimeout = config.timeOut;
    dio.options.followRedirects = config.followRedirect;
    dio.options.headers = config.headers;
    if (config.includeLogger) dio.interceptors.add(HttpFormatter(includeResponseBody: false));

    return dio;
  }
}
