import 'AppException.dart';

class InvalidInputException extends AppException {
  InvalidInputException(String message)
      : super(message, prefix: "Invalid Input: ");
}
