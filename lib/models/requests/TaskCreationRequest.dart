import 'package:json_annotation/json_annotation.dart';

part 'TaskCreationRequest.g.dart';

@JsonSerializable()
class TaskCreationRequest {
  final String text;

  TaskCreationRequest({required this.text});

  Map<String, dynamic> toJson() => _$TaskCreationRequestToJson(this);
}
