import 'package:gobz_app/exceptions/api/ApiException.dart';

class FetchDataException extends ApiException {
  FetchDataException(int statusCode, String message) : super(statusCode, message, "Error During Communication: ");
}
