import 'package:gobz_app/exceptions/AppException.dart';
import 'package:gobz_app/mixins/DisplayableMessage.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class DisplayableException extends AppException with DisplayableMessage {
  final String? _internMessage;
  final Exception? _internException;
  final String _messageToDisplay;

  DisplayableException(
    String messageToDisplay, {
    String? errorMessage,
    Exception? error,
    bool logExceptionOnCreate = true,
  })  : _messageToDisplay = messageToDisplay,
        _internMessage = errorMessage,
        _internException = error,
        super(errorMessage ?? error?.toString() ?? messageToDisplay) {
    if (logExceptionOnCreate) {
      logInternException();
    }
  }

  @override
  String get displayableMessage => _messageToDisplay;

  String get internMessage {
    String message = _internMessage ?? "";
    message += _internMessage != null && _internException != null ? ": " : "";
    message += _internException?.toString() ?? "";

    if (message.length == 0) {
      message = _messageToDisplay;
    }

    return message;
  }

  void logInternException() {
    Log.error(internMessage, _internException ?? this);
  }
}
