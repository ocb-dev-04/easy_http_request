import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:easy_http_request/core/constants/messages.dart';

import 'package:easy_http_request/data/easy_http_request_models.dart';

/// Class to configure the http client (Dio)
class EasyHttpClient {
  /// Dio instance for single client config
  static late SingleClientInstance? singleClient;

  /// Dio instance for many client config
  static List<ManyClientInstances> manyClient = List<ManyClientInstances>.empty(growable: true);

  /// Get instance of Dio from some list
  static SingleClientInstance getFromMany(String identifier) {
    final find = manyClient.firstWhere((element) => element.identifier == identifier, orElse: () => throw Exception(KMessages.notFoundIdentifier));
    return SingleClientInstance(dio: find.dio, config: find.config);
  }

  /// Allows access to the previously configured http client (single endpoint)
  static void setSingleClient({required EasyHttpConfig config}) => singleClient = SingleClientInstance(
        dio: _setDio(config),
        config: config,
      );

  /// Allows access to the previously configured http client (many endpoint)
  static void setManyClient({required List<EasyHttpConfig> config}) => manyClient = config.map((e) {
        final duplicated = _duplicatedIdentifier(newIdentifier: e.identifier);
        if (duplicated) throw Exception(KMessages.duplicatedIdentifier.replaceAll('@', e.identifier));

        return ManyClientInstances(dio: _setDio(e), identifier: e.identifier, config: e);
      }).toList();

  /// Change http client settings when client was initialized (single client)
  static void changeSingleHttpClientConfig({required EasyChangeHttpConfig config}) => singleClient == null
      ? throw Exception(KMessages.duplicatedIdentifier.replaceAll('@', config.identifier))
      : setSingleClient(config: _setToChangeHttpConfig(config, singleClient!.config));

  /// Change http client settings when client was initialized (collection client)
  static void changeManyHttpClientConfig({required EasyChangeHttpConfig config}) {
    _duplicatedIdentifier(newIdentifier: config.identifier);
    final oldConfig =
        manyClient.firstWhere(((element) => element.identifier == config.identifier), orElse: () => throw Exception(KMessages.notFoundIdentifier));
    manyClient
      ..removeWhere((element) => element.identifier == config.identifier)
      ..add(ManyClientInstances(
          dio: _setDio(_setToChangeHttpConfig(config, oldConfig.config)),
          identifier: config.identifier,
          config: _setToChangeHttpConfig(config, oldConfig.config)));
  }

  static bool _duplicatedIdentifier({required String newIdentifier}) => manyClient.any((element) => element.identifier == newIdentifier);

  static Dio _setDio(EasyHttpConfig e) {
    final dio = Dio();
    dio.options.baseUrl = '${e.apiPath}/';
    dio.options.connectTimeout = e.timeOut!;
    dio.options.followRedirects = e.followRedirect!;
    dio.options.headers = e.headers;
    if (e.includeLogger!) dio.interceptors.add(HttpFormatter(includeResponseBody: false));
    return dio;
  }

  static EasyHttpConfig _setToChangeHttpConfig(EasyChangeHttpConfig config, EasyHttpConfig oldConfig) => EasyHttpConfig(
      apiPath: config.apiPath ?? oldConfig.apiPath,
      identifier: config.identifier,
      headers: oldConfig.headers == null
          ? config.headers
          : () {
              oldConfig.headers!.addAll(config.headers!);
              return oldConfig;
            },
      followRedirect: config.followRedirect ?? oldConfig.followRedirect,
      includeLogger: config.includeLogger ?? oldConfig.includeLogger,
      timeOut: config.timeOut ?? oldConfig.timeOut,
      validStatus: config.validStatus ?? oldConfig.validStatus);
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
