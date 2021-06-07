import 'package:gobz_app/data/models/RunTask.dart';
import 'package:gobz_app/data/models/enums/RunStatus.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Project.dart';
import 'ProjectMember.dart';
import 'Step.dart';

part 'Run.g.dart';

@JsonSerializable()
class Run {
  final int id;
  final Step step;
  final Project project;
  final ProjectMember owner;
  final List<RunTask> tasks;
  final RunStatus status;
  final bool hasLimitDate;
  final DateTime limitDate;
  final double? completion;

  Run(
    this.id,
    this.step,
    this.project,
    this.owner,
    this.tasks,
    this.status,
    this.hasLimitDate,
    this.limitDate,
    this.completion,
  );

  factory Run.fromJson(Map<String, dynamic> json) => _$RunFromJson(json);
}
