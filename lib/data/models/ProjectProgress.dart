import 'package:json_annotation/json_annotation.dart';

part 'ProjectProgress.g.dart';

@JsonSerializable()
class ProjectProgress {
  final double completion;
  final int chaptersAmount;
  final int stepsAmount;
  final int tasksAmount;
  final int tasksDoneAmount;

  ProjectProgress(this.completion, this.chaptersAmount, this.stepsAmount, this.tasksAmount, this.tasksDoneAmount);

  factory ProjectProgress.fromJson(Map<String, dynamic> json) => _$ProjectProgressFromJson(json);
}
