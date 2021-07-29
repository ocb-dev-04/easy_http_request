/// Abstract class that must be implemented by the models that
/// will later be sent to the methods of the package.
///
/// Example:
///
/// getOne<[T]>() ---> T = Model that implements HttpDataParser
abstract class HttpDataParser<T> {
  /// Convert json data to model [T]
  T fromJson(Map<String, dynamic> json);

  /// Convert model [T] to json
  Map<String, dynamic> toJson();
}
