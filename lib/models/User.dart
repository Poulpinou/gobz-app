import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String? imageUrl;

  const User(
      {required this.id,
      required this.name,
      required this.email,
      this.imageUrl});

  static const User empty = User(id: 0, name: "unknown", email: "");

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
