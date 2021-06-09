import 'package:gobz_app/data/models/Project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProjectInfos.g.dart';

@JsonSerializable()
class ProjectInfos {
  final int id;
  final String name;
  final String description;
  final bool isShared;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProjectInfos(this.id, this.name, this.description, this.isShared, this.createdAt, this.updatedAt);

  factory ProjectInfos.fromJson(Map<String, dynamic> json) => _$ProjectInfosFromJson(json);

  factory ProjectInfos.fromProject(Project project) =>
      ProjectInfos(project.id, project.name, project.description, project.isShared, null, null);
}
