import 'package:dio/dio.dart';

/// Class used to initialize the package
class EasyHttpConfig {
  /// Model that is requested when initializing the package.
  ///
  /// It has the basic information both for the creation of the hhtp client
  /// and to validate the maximum status code with which it can be interpreted
  /// that a request is invalid or not.
  EasyHttpConfig({
    required this.baseApi,
    this.headers = const {},
    this.timeOut = 30 * 1000,
    this.validStatus = 204,
    this.followRedirect = false,
    this.includeLogger = true,
  });

  /// Base URL of your service
  late String baseApi;

  /// Headers you want to include in your queries
  late Map<String, dynamic> headers;

  /// Timeout to request data from the server
  late int timeOut;

  /// Valid status code for the request to be interpreted as complete
  /// or incomplete.
  ///
  /// Example:
  ///
  /// If your service returns a 200 Ok, a 201 Created and a 204 NotContent
  /// your [validStatusCode] is the highest number in this case 204
  late int validStatus;

  /// If you want to follow the redirects. By default is false
  late bool followRedirect;

  /// If you want a log of the query you are doing at that time to be displayed.
  ///
  /// Recommended for development. For testing and production it is
  /// not necessary.
  late bool includeLogger;
}

/// Class that contains the standard response model in the methods
class EasyHttpRequestResponse<T> {
  /// Standard response model when a package method is invoked
  EasyHttpRequestResponse({
    this.completeResponse,
    this.modelResponse,
    this.modelResponseAsList,
  });

  /// The information itself of the http client such as:
  ///
  /// StatusCode
  ///
  /// Data
  ///
  /// Headers
  ///
  /// StatusMessage, etc
  Response<dynamic>? completeResponse;

  /// The information of the MODEL itself
  ///
  /// Applies only for the [onGetOne]
  T? modelResponse;

  /// The information of the COLLECTION of the model.
  ///
  /// Applies only for the [onGetMany]
  List<T>? modelResponseAsList;
}
