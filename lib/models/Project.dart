import 'package:json_annotation/json_annotation.dart';

part 'Project.g.dart';

@JsonSerializable()
class Project {
  final String name;

  Project(this.name);

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}