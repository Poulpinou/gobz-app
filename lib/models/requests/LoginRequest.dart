import 'package:json_annotation/json_annotation.dart';

part 'LoginRequest.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest(this.email, this.password);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
