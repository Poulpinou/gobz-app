class InputError {
  final String message;

  InputError(this.message);

  factory InputError.empty() => InputError("Ce champs ne peut pas être vide");
}

class IdentifiedInputError<T> extends InputError {
  final T? identifier;

  IdentifiedInputError(String message, this.identifier) : super(message);
}
