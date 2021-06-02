import 'package:json_annotation/json_annotation.dart';

part 'RunTask.g.dart';

@JsonSerializable()
class RunTask {
  final int id;
  final String text;
  final bool isDone;
  final bool isAbandoned;

  RunTask(this.id, this.text, this.isDone, this.isAbandoned);

  factory RunTask.fromJson(Map<String, dynamic> json) => _$RunTaskFromJson(json);
}
