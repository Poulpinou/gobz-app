import 'package:json_annotation/json_annotation.dart';

part 'TaskUpdateRequest.g.dart';

@JsonSerializable()
class TaskUpdateRequest {
  final String text;

  TaskUpdateRequest({required this.text});

  Map<String, dynamic> toJson() => _$TaskUpdateRequestToJson(this);
}
