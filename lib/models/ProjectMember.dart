import 'package:gobz_app/mixins/DisplayableAvatar.dart';
import 'package:gobz_app/models/enums/ProjectRole.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProjectMember.g.dart';

@JsonSerializable()
class ProjectMember with DisplayableAvatar {
  final int id;
  final String name;
  final String? imageUrl;
  final ProjectRole role;

  const ProjectMember({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.role,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) => _$ProjectMemberFromJson(json);

  @override
  String? get avatarImageUrl => imageUrl;

  @override
  String get avatarText => name;
}
