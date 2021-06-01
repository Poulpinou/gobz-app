import 'package:gobz_app/exceptions/api/ApiException.dart';

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(400, message, "Invalid Request: ");
}
