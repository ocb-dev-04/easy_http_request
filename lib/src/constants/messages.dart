/// Error messages list
abstract class KMessages {
  /// Not found identifier error
  static const String notFoundIdentifier = 'Identifier >> @ << not found. NOTE: Remember use constants to avoid wrong name error';

  /// Not found key in headers
  static const String notFoundKeyIInHeaders = 'Key >> @ << not found into current headers. NOTE: Remember use constants to avoid wrong name error';

  /// Duplicated identifier error
  static const String duplicatedIdentifier = 'The indentifier >> @ << is duplicated';

  /// Use localhost url in prod mode
  static const String useLocalhostInProd = 'You can\'t use from a local url in a non-debug mode';
}
