import 'package:gobz_app/exceptions/AppException.dart';
import 'package:gobz_app/mixins/DisplayableMessage.dart';

class DisplayableException extends AppException with DisplayableMessage {
  final String internMessage;
  final String messageToDisplay;

  DisplayableException({required this.internMessage, required this.messageToDisplay}) : super(internMessage);

  @override
  String get displayableMessage => messageToDisplay;
}
