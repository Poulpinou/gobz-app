import 'package:json_annotation/json_annotation.dart';

part 'StepUpdateRequest.g.dart';

@JsonSerializable()
class StepUpdateRequest {
  final String name;
  final String description;

  StepUpdateRequest({required this.name, required this.description});

  Map<String, dynamic> toJson() => _$StepUpdateRequestToJson(this);
}
