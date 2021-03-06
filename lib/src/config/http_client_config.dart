import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:easy_http_request/src/constants/messages.dart';

import 'package:easy_http_request/src/models/easy_http_request_models.dart';
import 'package:flutter/foundation.dart';

/// Class to configure the http client (Dio)
class EasyHttpClient {
  /// Dio instance for single client config
  static late SingleClientInstance singleClient;

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
  static void setManyClient({required List<EasyHttpConfig> config}) => manyClient = config.asMap().entries.map((e) {
        final duplicated = _duplicatedIdentifier(newIdentifier: e.value.identifier);
        if (duplicated) throw Exception(KMessages.duplicatedIdentifier.replaceAll('@', e.value.identifier));
        debugPrint('EasyHttpRequest LOG >>> API PATH #${e.key + 1} >>> ID = ${e.value.identifier} >>> API PATH = ${e.value.apiPath}');
        return ManyClientInstances(dio: _setDio(e.value), identifier: e.value.identifier, config: e.value);
      }).toList();

  /// Add header when client was initialized (single client)
  static void addHeadersSingleClient({required Map<String, dynamic> newHeaders}) => setSingleClient(config: _addNewHeaders(newHeaders, singleClient.config));

  /// Update header when client was initialized (single client)
  static void updateHeadersSingleClient({required String key, required dynamic value}) => setSingleClient(
          config: _updateOrRemoveNewHeaders(
        key: key,
        valueIfToUpdate: value,
        oldConfig: singleClient.config,
      ));

  /// Remove header when client was initialized (single client)
  static void removeHeadersSingleClient({required String key}) => setSingleClient(
          config: _updateOrRemoveNewHeaders(
        key: key,
        oldConfig: singleClient.config,
        toUpdate: false,
      ));

  /// Add header when client was initialized (collection client)
  static void addHeadersManyClient({required String identifier, required Map<String, dynamic> newHeaders}) {
    _duplicatedIdentifier(newIdentifier: identifier);
    final oldConfig = manyClient.firstWhere(((element) => element.identifier == identifier), orElse: () => throw Exception(KMessages.notFoundIdentifier));
    manyClient
      ..removeWhere((element) => element.identifier == identifier)
      ..add(ManyClientInstances(
          dio: _setDio(_addNewHeaders(newHeaders, oldConfig.config)), identifier: identifier, config: _addNewHeaders(newHeaders, oldConfig.config)));
  }

  /// Update header when client was initialized (collection client)
  static void updateHeadersManyClient({required String identifier, required String key, required dynamic value}) {
    _duplicatedIdentifier(newIdentifier: identifier);

    final oldConfig = manyClient.firstWhere(((element) => element.identifier == identifier), orElse: () => throw Exception(KMessages.notFoundIdentifier));
    final newConfig = _updateOrRemoveNewHeaders(key: key, valueIfToUpdate: value, oldConfig: oldConfig.config);

    manyClient
      ..removeWhere((element) => element.identifier == identifier)
      ..add(ManyClientInstances(dio: _setDio(newConfig), identifier: identifier, config: newConfig));
  }

  /// Remove header when client was initialized (collection client)
  static void removeHeadersManyClient({required String identifier, required String key}) {
    _duplicatedIdentifier(newIdentifier: identifier);
    final oldConfig = manyClient.firstWhere(((element) => element.identifier == identifier), orElse: () => throw Exception(KMessages.notFoundIdentifier));
    final newConfig = _updateOrRemoveNewHeaders(key: key, toUpdate: false, oldConfig: oldConfig.config);
    manyClient
      ..removeWhere((element) => element.identifier == identifier)
      ..add(ManyClientInstances(dio: _setDio(newConfig), identifier: identifier, config: newConfig));
  }

  static Dio _setDio(EasyHttpConfig e) {
    final dio = Dio();
    dio.options.baseUrl = '${e.apiPath}/';
    dio.options.connectTimeout = e.timeOut;
    dio.options.followRedirects = e.followRedirect;
    dio.options.headers = e.headers;
    if (e.includeLogger) dio.interceptors.add(HttpFormatter(includeResponseBody: false));

    return dio;
  }

  static EasyHttpConfig _addNewHeaders(Map<String, dynamic> newHeaders, EasyHttpConfig oldConfig) {
    newHeaders.addAll(oldConfig.headers);
    oldConfig.headers = newHeaders;
    return oldConfig;
  }

  static EasyHttpConfig _updateOrRemoveNewHeaders({
    required String key,
    required EasyHttpConfig oldConfig,
    String valueIfToUpdate = '',
    bool toUpdate = true,
  }) {
    final contains = oldConfig.headers.containsKey(key);
    if (!contains) throw Exception(KMessages.notFoundKeyIInHeaders.replaceAll('@', key));

    toUpdate ? oldConfig.headers.update(key, (value) => value = valueIfToUpdate) : oldConfig.headers.remove(key);
    return oldConfig;
  }

  static bool _duplicatedIdentifier({required String newIdentifier}) => manyClient.any((element) => element.identifier == newIdentifier);
}

/// Class for create instances of dio and respective label (identifiers)
class SingleClientInstance {
  /// Contruct to set dio instance and config
  SingleClientInstance({required this.dio, required this.config});

  /// Dio instance
  Dio dio;

  /// Config for http client
  EasyHttpConfig config;
}

/// Class for create instances of dio and respective label (identifiers)
class ManyClientInstances {
  /// Contruct to set dio instance and label
  ManyClientInstances({required this.dio, required this.identifier, required this.config});

  /// Dio instance
  Dio dio;

  /// Config for http client
  EasyHttpConfig config;

  /// Api path identifier
  String identifier;
}
