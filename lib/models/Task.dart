import 'package:json_annotation/json_annotation.dart';

part 'Task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String text;
  final bool isDone;

  Task(this.id, this.text, this.isDone);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
