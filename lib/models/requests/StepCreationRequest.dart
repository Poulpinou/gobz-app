import 'package:json_annotation/json_annotation.dart';

part 'StepCreationRequest.g.dart';

@JsonSerializable()
class StepCreationRequest {
  final String name;
  final String description;

  StepCreationRequest({required this.name, required this.description});

  Map<String, dynamic> toJson() => _$StepCreationRequestToJson(this);
}
