import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';

import 'package:easy_http_request/data/easy_http_request_models.dart';

/// Class to configure the http client (Dio)
class EasyHttpClient {
  /// Dio instance for single client config
  static late SingleClientInstance singleClient;

  /// Dio instance for many client config
  static late List<ManyClientInstances> manyClient;

  /// Get instance of Dio from some list
  static SingleClientInstance getFromMany(String identifier) {
    final find = manyClient.firstWhere((element) => element.identifier == identifier,
        orElse: () => throw Exception(
              'Identifier name not found. Remember use constants to avoid wrong name error',
            ));
    return SingleClientInstance(dio: find.dio, config: find.config);
  }

  /// Allows access to the previously configured http client (single endpoint)
  static void setSingleClient({required EasyHttpConfig config}) => singleClient = SingleClientInstance(
        dio: _setDio(config),
        config: config,
      );

  /// Allows access to the previously configured http client (many endpoint)
  static void setManyClient({required List<EasyHttpConfig> config}) => manyClient = config.map((e) {
        return ManyClientInstances(
          dio: _setDio(e),
          identifier: e.label,
          config: e,
        );
      }).toList();

  static Dio _setDio(EasyHttpConfig e) {
    final dio = Dio();
    dio.options.baseUrl = '${e.apiPath}/';
    dio.options.connectTimeout = e.timeOut;
    dio.options.followRedirects = e.followRedirect;
    dio.options.headers = e.headers;
    if (e.includeLogger) dio.interceptors.add(HttpFormatter(includeResponseBody: false));
    return dio;
  }
}

/// Class for create instances of dio and respective label (identifiers)
class SingleClientInstance {
  /// Contruct to set dio instance and config
  SingleClientInstance({required this.dio, required this.config});

  /// Dio instance
  final Dio dio;

  /// Config for http client
  final EasyHttpConfig config;
}

/// Class for create instances of dio and respective label (identifiers)
class ManyClientInstances {
  /// Contruct to set dio instance and label
  ManyClientInstances({required this.dio, required this.identifier, required this.config});

  /// Dio instance
  final Dio dio;

  /// Config for http client
  final EasyHttpConfig config;

  /// Api path identifier
  final String identifier;
}
