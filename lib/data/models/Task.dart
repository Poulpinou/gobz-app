import 'package:gobz_app/data/models/ProjectMember.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String text;
  final bool isDone;
  final List<ProjectMember>? workers;
  final bool? isWorkingOnIt;

  Task(this.id, this.text, this.isDone, this.workers, this.isWorkingOnIt);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Task && id == other.id;
}
