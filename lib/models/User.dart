import 'package:gobz_app/mixins/DisplayableAvatar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User with DisplayableAvatar {
  final int id;
  final String name;
  final String email;
  final String? imageUrl;

  const User({required this.id, required this.name, required this.email, this.imageUrl});

  static const User empty = User(id: 0, name: "unknown", email: "");

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  String? get avatarImageUrl => imageUrl;

  @override
  String get avatarText => name;
}
