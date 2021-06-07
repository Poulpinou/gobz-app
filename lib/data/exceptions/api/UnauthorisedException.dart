import 'package:gobz_app/data/exceptions/api/ApiException.dart';

class UnauthorisedException extends ApiException {
  UnauthorisedException(int statusCode, String message) : super(statusCode, message, "Unauthorised: ");
}
