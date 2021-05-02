import 'package:gobz_app/models/ProgressInfos.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Project.dart';

part 'ProjectInfos.g.dart';

@JsonSerializable()
class ProjectInfos {
  final Project project;
  final ProgressInfos progressInfos;

  ProjectInfos(this.project, this.progressInfos);

  factory ProjectInfos.fromJson(Map<String, dynamic> json) => _$ProjectInfosFromJson(json);
}
