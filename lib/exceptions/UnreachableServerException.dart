import 'package:gobz_app/mixins/DisplayableMessage.dart';

import 'AppException.dart';

class UnreachableServerException extends AppException with DisplayableMessage {
  UnreachableServerException() : super("Server connection failed");

  @override
  String get displayableMessage => "Connexion au server impossible";
}
