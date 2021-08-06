import 'package:easy_http_request/src/config/http_client_config.dart';
import 'package:easy_http_request/src/models/easy_http_request_models.dart';

/// Class initializer at package
class EasyHttpSettings {
  /// Method to initialize the package with just a endpoint (base url - baseApi)
  static void initWithSingleApi({required EasyHttpConfig config}) =>
      EasyHttpClient.setSingleClient(config: config);

  /// Method to initialize the package with many a endpoint (base url - baseApi)
  static void initWithManyApi({required List<EasyHttpConfig> config}) =>
      EasyHttpClient.setManyClient(config: config);
}

/// Code to manage headers when http client is running
class EasyHeadersManager {
  ///  Add headers when client was initialized (single client)
  static void addHeadersSingleClient(
          {required Map<String, dynamic> newHeaders}) =>
      EasyHttpClient.addHeadersSingleClient(newHeaders: newHeaders);

  ///  Update headers when client was initialized (single client)
  static void updateHeadersSingleClient(
          {required String key, required String value}) =>
      EasyHttpClient.updateHeadersSingleClient(key: key, value: value);

  ///  Remove headers when client was initialized (single client)
  static void removeHeadersSingleClient({required String key}) =>
      EasyHttpClient.removeHeadersSingleClient(key: key);

  /// Add headers when client was initialized (collection client)
  static void addHeadersManyClient(
          {required String identifier,
          required Map<String, dynamic> newHeaders}) =>
      EasyHttpClient.addHeadersManyClient(
          identifier: identifier, newHeaders: newHeaders);

  /// Update headers when client was initialized (collection client)
  static void updateHeadersManyClient(
          {required String identifier,
          required String key,
          required String value}) =>
      EasyHttpClient.updateHeadersManyClient(
          identifier: identifier, key: key, value: value);

  /// Remove headers when client was initialized (collection client)
  static void removeHeadersManyClient(
          {required String identifier, required String key}) =>
      EasyHttpClient.removeHeadersManyClient(identifier: identifier, key: key);
}
