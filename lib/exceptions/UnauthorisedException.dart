import 'AppException.dart';

class UnauthorisedException extends AppException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}
