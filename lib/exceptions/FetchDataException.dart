
import 'AppException.dart';

class FetchDataException extends AppException {
  FetchDataException(String message)
      : super(message, "Error During Communication: ");
}
