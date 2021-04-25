import 'AppException.dart';

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, "Invalid Request: ");
}