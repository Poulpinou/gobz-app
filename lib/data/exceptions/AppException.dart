abstract class AppException implements Exception {
  final String message;
  final String? _prefix;

  AppException(this.message, {String? prefix}) : this._prefix = prefix;

  String toString() {
    return "${_prefix ?? ""}$message";
  }
}
