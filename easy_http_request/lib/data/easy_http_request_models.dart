import 'package:dio/dio.dart';

class HttpConfigData {
  late String baseApi;
  late Map<String, dynamic> headers;
  late int timeOut;
  late int validStatus;
  late bool followRedirect;
  late bool includeLogger;

  HttpConfigData({
    required this.baseApi,
    this.headers = const {},
    this.timeOut = 30 * 1000,
    this.validStatus = 201,
    this.followRedirect = false,
    this.includeLogger = true,
  });
}

class EasyHttpRequestResponse<T> {
  Response<dynamic> completeResponse;
  T? modelResponse;
  List<T>? modelResponseAsList;

  EasyHttpRequestResponse({
    required this.completeResponse,
    this.modelResponse,
    this.modelResponseAsList,
  });
}
