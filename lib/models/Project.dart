import 'package:json_annotation/json_annotation.dart';

part 'Project.g.dart';

@JsonSerializable()
class Project {
  final int id;
  final String name;
  final String description;

  Project(this.id, this.name, this.description);

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
