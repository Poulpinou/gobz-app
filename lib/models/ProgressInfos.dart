import 'package:json_annotation/json_annotation.dart';

part 'ProgressInfos.g.dart';

@JsonSerializable()
class ProgressInfos {
  final int chaptersAmount;
  final int stepsAmount;
  final int tasksAmount;
  final int tasksDoneAmount;

  ProgressInfos(this.chaptersAmount, this.stepsAmount, this.tasksAmount, this.tasksDoneAmount);

  factory ProgressInfos.fromJson(Map<String, dynamic> json) => _$ProgressInfosFromJson(json);
}
