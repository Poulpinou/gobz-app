// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SignInRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInRequest _$SignInRequestFromJson(Map<String, dynamic> json) {
  return SignInRequest(
    json['name'] as String,
    json['email'] as String,
    json['password'] as String,
  );
}

Map<String, dynamic> _$SignInRequestToJson(SignInRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
