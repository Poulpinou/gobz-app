import 'package:gobz_app/data/exceptions/AppException.dart';

abstract class ApiException extends AppException {
  final int statusCode;

  ApiException(this.statusCode, String message, String prefix) : super(message, prefix: "$statusCode $prefix");
}
