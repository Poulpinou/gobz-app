import 'package:json_annotation/json_annotation.dart';

part 'SignInRequest.g.dart';

@JsonSerializable()
class SignInRequest {
  final String name;
  final String email;
  final String password;

  SignInRequest(this.name, this.email, this.password);

  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}
